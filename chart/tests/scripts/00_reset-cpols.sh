#!/bin/bash
# ---------------------------------------------------------------------------
# 00_reset-cpols.sh — Pre-flight CPol action reset
# ---------------------------------------------------------------------------
# Gluon may re-run the test pod after a successful pass. EXIT traps from the
# previous run can't reliably restore CPol state because gluon kills the pod
# before they complete. This script heals any drift by patching each CPol's
# validationFailureAction back to the chart-rendered expected value.
#
# Reads CPOL_ACTIONS env var (space-separated name=action pairs) set by the
# Helm chart. Exits 0 if the var is unset (backward compat).
# ---------------------------------------------------------------------------
source "$(dirname "$0")/_helpers.sh"

if [[ -z "${CPOL_ACTIONS:-}" ]]; then
  echo -e "${_YEL}CPOL_ACTIONS not set — skipping CPol reset${_NC}"
  exit 0
fi

echo -e "${_CYN}Pre-flight: resetting CPol validationFailureActions${_NC}"
for pair in $CPOL_ACTIONS; do
  name="${pair%%=*}"
  expected="${pair#*=}"

  current=$(kubectl get cpol "$name" -o jsonpath='{.spec.validationFailureAction}' 2>/dev/null) || continue
  if [[ "$current" != "$expected" ]]; then
    kubectl patch cpol "$name" \
      -p "{\"spec\":{\"validationFailureAction\":\"${expected}\"}}" --type=merge
    echo -e "  ${name}: ${current} → ${expected}"
  fi
done
echo -e "${_GRN}Pre-flight complete${_NC}"
