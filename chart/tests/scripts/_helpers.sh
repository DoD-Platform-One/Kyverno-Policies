#!/bin/bash
# ---------------------------------------------------------------------------
# _helpers.sh — Shared helpers for gluon bbtest scripts
# ---------------------------------------------------------------------------
# Gluon will "execute" this file as a script — the only top-level side effect
# is a timestamp log (see bottom). Test scripts source this file and call the
# functions they need.
#
# Usage (from a test script):
#   source "$(dirname "$0")/_helpers.sh"
#   preflight_vpol
# ---------------------------------------------------------------------------

# --- Colors ---------------------------------------------------------------
_RED='\033[0;31m'
_GRN='\033[0;32m'
_YEL='\033[0;33m'
_CYN='\033[0;36m'
_NC='\033[0m'

# --- Preflight checks ----------------------------------------------------

# Verify that all listed binaries are on PATH. Exits non-zero with a clear
# message if any are missing.
preflight_require_binaries() {
  local missing=()
  for bin in "$@"; do
    if ! command -v "$bin" >/dev/null 2>&1; then
      missing+=("$bin")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    echo -e "${_RED}PREFLIGHT FAIL${_NC}: missing required binaries: ${missing[*]}"
    echo "Expected in devops-tester:1.1 — is the correct bbtest image configured?"
    exit 1
  fi
}

# Verify that grep supports -E (extended regex) and -o (only matching).
# BusyBox grep supports these; GNU grep -P (Perl) is NOT guaranteed.
preflight_require_grep_extended() {
  if ! echo "test123" | grep -oE '[0-9]+' >/dev/null 2>&1; then
    echo -e "${_RED}PREFLIGHT FAIL${_NC}: grep does not support -oE (extended regex)"
    exit 1
  fi
}

# Run all standard preflight checks for VPol test scripts.
preflight_vpol() {
  preflight_require_binaries kubectl kyverno chainsaw jq
  preflight_require_grep_extended
}

# --- Fixture reconstruction -----------------------------------------------
# ConfigMap keys use __ as path separator (e.g. tests__vpol__foo__kyverno-test__bar.yaml).
# Strip the leading tests__vpol__ prefix and recreate the nested directory tree.
#
# Globals: VPOL_MOUNT (source), WORKDIR (destination), both set by caller.
reconstruct_fixtures() {
  mkdir -p "${WORKDIR}"
  for key_file in "${VPOL_MOUNT}"/*; do
    key="$(basename "${key_file}")"
    rel_path="${key//__//}"
    rel_path="${rel_path#tests/vpol/}"
    target="${WORKDIR}/${rel_path}"
    mkdir -p "$(dirname "${target}")"
    cp "${key_file}" "${target}"
  done
}

# --- Policy quiet/restore helpers ----------------------------------------
# Patch all CPols/VPols to Audit before tests, restore after.
# Prevents cross-policy interference during targeted enforce/deny testing.

# Gluon kills the test pod on completion, which can race with our EXIT traps.
# If the API server is already unreachable, kubectl hangs for 30s+ per call.
# This cap lets restore_ functions fail fast and exit cleanly.
RESTORE_TIMEOUT="5s"

# Poll multiple VPol bindings in a single loop instead of waiting for each
# one sequentially. With N bindings the old approach could block for up to
# N*TIMEOUT seconds; this caps it at TIMEOUT total.
#
# How it works: each tick we check every still-pending binding. If its
# validationActions[0] matches the target, we log success and drop it from the
# list. Once the list is empty (or we hit the timeout) we stop.
#
# Usage: wait_for_vpol_bindings ACTION TIMEOUT NAME [NAME ...]
wait_for_vpol_bindings() {
  local action=$1
  local timeout=$2
  shift 2
  local -a pending=("$@")

  if [[ ${#pending[@]} -eq 0 ]]; then return 0; fi

  echo -e "  waiting for ${#pending[@]} vpol binding(s) to reconcile..."
  local elapsed=0
  while [[ ${#pending[@]} -gt 0 && "$elapsed" -le "$timeout" ]]; do
    # Check every binding that hasn't reconciled yet
    local -a still_waiting=()
    for name in "${pending[@]}"; do
      local current
      current=$(kubectl get validatingadmissionpolicybinding "$name" \
        -o jsonpath='{.spec.validationActions[0]}' 2>/dev/null || true)
      if [[ "$current" = "$action" ]]; then
        echo -e "    ${name}: ${_GRN}OK${_NC} (${elapsed}s)"
      else
        still_waiting+=("$name")
      fi
    done
    # Replace pending with only the bindings that aren't ready yet
    pending=("${still_waiting[@]}")
    if [[ ${#pending[@]} -gt 0 ]]; then
      ((elapsed+=1))
      sleep 1
    fi
  done

  # Anything still in the list never reconciled within the timeout
  for name in "${pending[@]}"; do
    echo -e "    ${name}: ${_YEL}TIMEOUT${_NC} (binding may still have stale action)"
  done
}

# Patch all CPols to Audit. Populates SAVED_CPOL_ACTIONS for restore_cpols.
quiet_cpols() {
  declare -gA SAVED_CPOL_ACTIONS
  local all_cpols
  all_cpols=$(kubectl get cpol --no-headers -o custom-columns=":metadata.name" 2>/dev/null || true)
  if [[ -z "$all_cpols" ]]; then return 0; fi

  echo -e "${_CYN}Setup: Set all cpols to Audit${_NC}"
  for cpol in $all_cpols; do
    local current
    # Empty output means the field isn't set — Audit is the correct default.
    # A non-zero exit is an API error; don't guess, fail so we don't silently
    # downgrade an Enforce policy to Audit with no restore.
    if ! current=$(kubectl get cpol "$cpol" -o jsonpath='{.spec.validationFailureAction}' 2>&1); then
      echo -e "${_RED}ERROR: could not read ${cpol}: ${current}${_NC}"
      return 1
    fi
    current="${current:-Audit}"
    SAVED_CPOL_ACTIONS[$cpol]="$current"
    if [ "$current" != "Audit" ]; then
      kubectl patch cpol "$cpol" -p '{"spec":{"validationFailureAction":"Audit"}}' --type=merge
    fi
  done
}

# Restore CPol validationFailureActions from SAVED_CPOL_ACTIONS.
# Called from EXIT traps; bails on first failure (see RESTORE_TIMEOUT).
restore_cpols() {
  if [[ ${#SAVED_CPOL_ACTIONS[@]} -eq 0 ]]; then return 0; fi
  echo -e "${_CYN}Cleanup: Restore cpol validationFailureActions${_NC}"
  for cpol in "${!SAVED_CPOL_ACTIONS[@]}"; do
    local original="${SAVED_CPOL_ACTIONS[$cpol]}"
    if [ "$original" != "Audit" ]; then
      if ! kubectl patch cpol "$cpol" --request-timeout="$RESTORE_TIMEOUT" \
           -p "{\"spec\":{\"validationFailureAction\":\"${original}\"}}" --type=merge 2>/dev/null; then
        echo -e "${_YEL}Cleanup: could not restore ${cpol}, API server may be gone${_NC}"
        return 0
      fi
    fi
  done
}

# Patch all VPols to Audit and poll bindings until reconciled.
# Populates SAVED_VPOL_ACTIONS for restore_vpols.
quiet_vpols() {
  declare -gA SAVED_VPOL_ACTIONS
  local all_vpols
  all_vpols=$(kubectl get vpol --no-headers -o custom-columns=":metadata.name" 2>/dev/null || true)
  if [[ -z "$all_vpols" ]]; then return 0; fi

  echo -e "${_CYN}Setup: Set all vpols to Audit${_NC}"
  for vpol in $all_vpols; do
    local current
    if ! current=$(kubectl get vpol "$vpol" -o jsonpath='{.spec.validationActions[0]}' 2>&1); then
      echo -e "${_RED}ERROR: could not read ${vpol}: ${current}${_NC}"
      return 1
    fi
    current="${current:-Audit}"
    SAVED_VPOL_ACTIONS[$vpol]="$current"
    if [ "$current" != "Audit" ]; then
      # JSON patch (not merge) because validationActions is an array —
      # merge-patch appends to arrays instead of replacing them.
      kubectl patch vpol "$vpol" --type=json \
        -p '[{"op":"replace","path":"/spec/validationActions","value":["Audit"]}]'
    fi
  done

  # Collect the VPols we actually patched above — only those need a binding
  # wait. VPols that were already Audit didn't change, so their bindings are
  # already correct.
  local -a changed=()
  for vpol in $all_vpols; do
    if [ "${SAVED_VPOL_ACTIONS[$vpol]}" != "Audit" ]; then
      changed+=("$vpol")
    fi
  done
  wait_for_vpol_bindings "Audit" 120 "${changed[@]}"
}

# Restore VPol validationActions from SAVED_VPOL_ACTIONS.
# Called from EXIT traps; bails on first failure (see RESTORE_TIMEOUT).
restore_vpols() {
  if [[ ${#SAVED_VPOL_ACTIONS[@]} -eq 0 ]]; then return 0; fi
  echo -e "${_CYN}Cleanup: Restore vpol validationActions${_NC}"
  for vpol in "${!SAVED_VPOL_ACTIONS[@]}"; do
    local original="${SAVED_VPOL_ACTIONS[$vpol]}"
    if [ "$original" != "Audit" ]; then
      if ! kubectl patch vpol "$vpol" --request-timeout="$RESTORE_TIMEOUT" --type=json \
           -p "[{\"op\":\"replace\",\"path\":\"/spec/validationActions\",\"value\":[\"${original}\"]}]" 2>/dev/null; then
        echo -e "${_YEL}Cleanup: could not restore ${vpol}, API server may be gone${_NC}"
        return 0
      fi
    fi
  done
}

# --- Timing ----------------------------------------------------------------
# Prints a UTC timestamp each time a script sources this file (or when gluon
# runs it directly). Diff consecutive timestamps to measure script duration.
echo -e "${_CYN}$(date -u '+%Y-%m-%dT%H:%M:%SZ') — ${BASH_SOURCE[0]##*/} sourced by ${0##*/}${_NC}"
