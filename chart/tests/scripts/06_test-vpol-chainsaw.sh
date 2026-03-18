#!/bin/bash
# ---------------------------------------------------------------------------
# test-vpol-chainsaw.sh — Live admission tests inside the gluon bbtest pod
# ---------------------------------------------------------------------------
# Discovers deployed ValidatingPolicies, reconstructs fixture directories
# from the vpol ConfigMap mount, then runs `chainsaw test` for each policy.
#
# Chainsaw applies the VPol (idempotent update), patches to Deny, waits for
# webhook readiness, then creates good/bad resources to verify admission.
#
# Prerequisites (provided by devops-tester:1.1):
#   bash, kubectl, chainsaw, jq
# ---------------------------------------------------------------------------
set -euo pipefail

source "$(dirname "$0")/_helpers.sh"
preflight_vpol

VPOL_MOUNT="/vpol"
WORKDIR="/test/vpol-chainsaw"

reconstruct_fixtures

# --- Discover deployed ValidatingPolicies ---------------------------------

DEPLOYED=$(kubectl get validatingpolicies -A -o jsonpath='{.items[*].metadata.name}' 2>/dev/null || true)
if [[ -z "${DEPLOYED}" ]]; then
  echo "SKIP: no ValidatingPolicies deployed — nothing to test"
  exit 0
fi

# Defang all CPols so they don't block chainsaw's test resources.
# Also quiet VPols — chainsaw patches its target to Deny internally,
# but other VPols could interfere. restore_vpols resets them (including
# the one chainsaw patched) so gluon re-runs start clean.
quiet_cpols
quiet_vpols
trap 'restore_vpols; restore_cpols' EXIT

# --- Extract policies and collect test dirs --------------------------------

test_dirs=()
for policy_name in ${DEPLOYED}; do
  chainsaw_test_dir="${WORKDIR}/${policy_name}/chainsaw-test"
  if [[ ! -d "${chainsaw_test_dir}" ]]; then
    echo "SKIP: no chainsaw-test fixtures for ${policy_name}"
    continue
  fi

  # Extract the deployed VPol so chainsaw-test.yaml can apply it
  policy_file="${WORKDIR}/${policy_name}/policy.yaml"
  kubectl get validatingpolicy "${policy_name}" -o yaml > "${policy_file}"

  if [[ ! -s "${policy_file}" ]]; then
    echo "ERROR: kubectl get produced empty output for ${policy_name}"
    continue
  fi

  test_dirs+=("${chainsaw_test_dir}")
done

# --- Run all chainsaw tests in a single invocation ------------------------
# Chainsaw runs tests in parallel by default when given multiple dirs.

if [[ ${#test_dirs[@]} -eq 0 ]]; then
  # Fail loud — if VPols are deployed, fixtures should exist. Zero matches
  # means a packaging or path error, not "nothing to do."
  echo "FAIL: no VPol chainsaw-test fixtures matched any deployed policy"
  exit 1
fi

echo "==> Running chainsaw on ${#test_dirs[@]} test dir(s)..."
chainsaw test "${test_dirs[@]}"

# Explicit restore in addition to the EXIT trap. The trap covers abnormal
# exits, but gluon's pod environment may not reliably deliver EXIT to
# subprocesses, so we restore here too.
restore_cpols
