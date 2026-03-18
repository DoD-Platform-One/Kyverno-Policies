#!/bin/bash
# ---------------------------------------------------------------------------
# test-vpol-kyverno.sh — Offline CEL evaluation inside the gluon bbtest pod
# ---------------------------------------------------------------------------
# Discovers deployed ValidatingPolicies, extracts them via kubectl, then runs
# `kyverno test` against fixtures mounted from the vpol ConfigMap.
#
# Prerequisites (provided by devops-tester:1.1):
#   bash, kubectl, kyverno, jq
# ---------------------------------------------------------------------------
set -euo pipefail

source "$(dirname "$0")/_helpers.sh"
preflight_vpol

VPOL_MOUNT="/vpol"
WORKDIR="/test/vpol-kyverno"

failures=0
tested=0

reconstruct_fixtures

# --- Discover deployed ValidatingPolicies ---------------------------------

DEPLOYED=$(kubectl get validatingpolicies -A -o jsonpath='{.items[*].metadata.name}' 2>/dev/null || true)
if [[ -z "${DEPLOYED}" ]]; then
  echo "SKIP: no ValidatingPolicies deployed — nothing to test"
  exit 0
fi

# --- Main loop: run kyverno test for each deployed VPol with fixtures -----

for policy_name in ${DEPLOYED}; do
  kyverno_test_dir="${WORKDIR}/${policy_name}/kyverno-test"
  if [[ ! -d "${kyverno_test_dir}" ]]; then
    echo "SKIP: no kyverno-test fixtures for ${policy_name}"
    continue
  fi

  echo "==> kyverno test: ${policy_name}"

  # Extract the deployed VPol as the policy.yaml that kyverno-test.yaml references
  policy_file="${WORKDIR}/${policy_name}/policy.yaml"
  kubectl get validatingpolicy "${policy_name}" -o yaml > "${policy_file}"

  if [[ ! -s "${policy_file}" ]]; then
    echo "    ERROR: kubectl get produced empty output for ${policy_name}"
    failures=$((failures + 1))
    continue
  fi

  if kyverno test "${kyverno_test_dir}" --detailed-results; then
    echo "    PASS: ${policy_name}"
  else
    echo "    FAIL: ${policy_name}"
    failures=$((failures + 1))
  fi

  tested=$((tested + 1))
done

# --- Summary --------------------------------------------------------------

echo ""
echo "==> ${tested} VPol kyverno test(s) run, ${failures} failure(s)"

if [[ "${tested}" -eq 0 ]]; then
  # Fail loud — if the gluon pod is running, VPols should be deployed and
  # have fixtures. Zero tests means a config error, not "nothing to do."
  echo "FAIL: no VPol kyverno-test fixtures matched any deployed policy"
  exit 1
fi

if [[ "${failures}" -gt 0 ]]; then
  exit 1
fi
