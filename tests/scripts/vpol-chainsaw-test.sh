#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# vpol-chainsaw-test.sh — Live-cluster integration tests for BB VPol templates
# ---------------------------------------------------------------------------
#
# Renders each celPoliciesBeta ValidatingPolicy via helm template, then runs
# its chainsaw test suite against a real cluster. Chainsaw applies the VPol,
# patches it to Deny, waits for the webhook, then creates good/bad resources
# to verify admission behavior end-to-end.
#
# Prerequisites:
#   - helm, yq, chainsaw on PATH
#   - A running cluster with Kyverno installed (VPol CRD available)
#   - No other enforcing policies that would reject the test fixtures
#     (uninstall kyverno-policies chart or set all CPols to Audit first)
#
# Test discovery:
#   Auto-discovers tests/vpol/**/.chainsaw-test/ directories. Each must have
#   a sibling .kyverno-test/kyverno-test.yaml to provide the policy name.
#
# Rendered artifacts:
#   Each test gets a transient policy.yaml rendered next to .chainsaw-test/.
#   All rendered files are cleaned up on exit (even on failure) via trap.
#
# Usage: tests/scripts/vpol-chainsaw-test.sh
# ---------------------------------------------------------------------------
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CHART_DIR="${REPO_ROOT}/chart"
TESTS_DIR="${REPO_ROOT}/tests/vpol"

failures=0
tested=0
rendered_files=()

# Clean up rendered policy.yaml files on exit, even if the script fails.
cleanup() {
  for f in "${rendered_files[@]}"; do
    rm -f "${f}"
  done
}
trap cleanup EXIT

# --- Main loop: discover and run each chainsaw test -----------------------

for test_dir in $(find "${TESTS_DIR}" -name '.chainsaw-test' -type d 2>/dev/null); do
  policy_dir="$(dirname "${test_dir}")"

  # The policy name comes from the sibling kyverno-test.yaml, which is the
  # single source of truth shared by both the kyverno CLI and chainsaw tests.
  kyverno_test="${policy_dir}/.kyverno-test/kyverno-test.yaml"
  if [[ ! -f "${kyverno_test}" ]]; then
    echo "SKIP: no .kyverno-test/kyverno-test.yaml alongside ${test_dir}"
    continue
  fi

  policy_name="$(yq '.metadata.name' "${kyverno_test}")"
  if [[ -z "${policy_name}" || "${policy_name}" == "null" ]]; then
    echo "ERROR: could not extract policy name from ${kyverno_test}"
    failures=$((failures + 1))
    continue
  fi

  echo "==> Chainsaw test: ${policy_name}"

  # Render the VPol from the Helm chart with only this policy enabled.
  # yq filters to the single ValidatingPolicy document — helm template
  # emits all chart resources, we only want the one under test.
  rendered="${policy_dir}/policy.yaml"
  helm template kp "${CHART_DIR}" \
    --set "celPoliciesBeta.${policy_name}.enabled=true" \
    | yq "select(.kind == \"ValidatingPolicy\" and .metadata.name == \"${policy_name}\")" \
    > "${rendered}"
  rendered_files+=("${rendered}")

  if [[ ! -s "${rendered}" ]]; then
    echo "ERROR: helm template produced no ValidatingPolicy for ${policy_name}"
    failures=$((failures + 1))
    continue
  fi

  # Run the chainsaw test. Chainsaw creates a temp namespace, applies the
  # rendered VPol, patches it to Deny, then exercises good/bad fixtures.
  if chainsaw test "${test_dir}"; then
    echo "    PASS: ${policy_name}"
  else
    echo "    FAIL: ${policy_name}"
    failures=$((failures + 1))
  fi

  tested=$((tested + 1))
done

# --- Summary --------------------------------------------------------------

if [[ "${tested}" -eq 0 ]]; then
  echo "ERROR: no VPol chainsaw-test directories found under ${TESTS_DIR}"
  exit 1
fi

echo ""
echo "==> ${tested} VPol chainsaw test(s) run, ${failures} failure(s)"

if [[ "${failures}" -gt 0 ]]; then
  exit 1
fi
