#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# vpol-kyverno-test.sh — Offline policy evaluation for BB VPol templates
# ---------------------------------------------------------------------------
#
# Renders each celPoliciesBeta ValidatingPolicy via helm template, then runs
# `kyverno test` to evaluate the CEL expressions against resource fixtures.
# No cluster required — this is a pure offline check that the CEL logic
# admits good resources and rejects bad ones.
#
# Prerequisites:
#   - helm, yq, kyverno CLI on PATH
#
# Test discovery:
#   Auto-discovers tests/vpol/**/.kyverno-test/ directories. Each contains
#   a kyverno-test.yaml (test manifest) and resource.yaml (test fixtures).
#
# Rendered artifacts:
#   Each test gets a transient policy.yaml rendered next to .kyverno-test/.
#   Cleaned up after each test (even on failure).
#
# Usage: tests/scripts/vpol-kyverno-test.sh
# ---------------------------------------------------------------------------
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CHART_DIR="${REPO_ROOT}/chart"
TESTS_DIR="${REPO_ROOT}/tests/vpol"

failures=0
tested=0

# --- Main loop: discover and run each kyverno test ------------------------

for test_dir in $(find "${TESTS_DIR}" -name '.kyverno-test' -type d 2>/dev/null); do
  policy_dir="$(dirname "${test_dir}")"

  # Extract the policy name from kyverno-test.yaml metadata.
  policy_name="$(yq '.metadata.name' "${test_dir}/kyverno-test.yaml")"

  if [[ -z "${policy_name}" || "${policy_name}" == "null" ]]; then
    echo "ERROR: could not extract policy name from ${test_dir}/kyverno-test.yaml"
    failures=$((failures + 1))
    continue
  fi

  echo "==> Testing VPol: ${policy_name}"

  # Render the VPol from the Helm chart with only this policy enabled.
  # yq filters to the single ValidatingPolicy document — helm template
  # emits all chart resources, we only want the one under test.
  rendered="${policy_dir}/policy.yaml"
  helm template kp "${CHART_DIR}" \
    --set "celPoliciesBeta.${policy_name}.enabled=true" \
    | yq "select(.kind == \"ValidatingPolicy\" and .metadata.name == \"${policy_name}\")" \
    > "${rendered}"

  if [[ ! -s "${rendered}" ]]; then
    echo "ERROR: helm template produced no ValidatingPolicy for ${policy_name}"
    rm -f "${rendered}"
    failures=$((failures + 1))
    continue
  fi

  # Run kyverno test offline — evaluates CEL expressions against fixtures.
  if kyverno test "${test_dir}" --detailed-results; then
    echo "    PASS: ${policy_name}"
  else
    echo "    FAIL: ${policy_name}"
    failures=$((failures + 1))
  fi

  # Clean up rendered artifact after each test.
  rm -f "${rendered}"
  tested=$((tested + 1))
done

# --- Summary --------------------------------------------------------------

if [[ "${tested}" -eq 0 ]]; then
  echo "ERROR: no VPol kyverno-test directories found under ${TESTS_DIR}"
  exit 1
fi

echo ""
echo "==> ${tested} VPol template(s) tested, ${failures} failure(s)"

if [[ "${failures}" -gt 0 ]]; then
  exit 1
fi
