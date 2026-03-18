# Testing Kyverno Policies

## How tests run

CI runs tests in two stages:

1. **Helm unit tests** (`helm unittest`) — run early in CI without a cluster. Fast, offline validation of template rendering.
2. **Gluon bbtest scripts** (`helm test`) — run inside a single pod against a live cluster. Three flavors:
   - *CPol integration tests* (legacy) — kubectl-based, must stay until their CPols are deleted at the end of the CEL migration
   - *CEL policy kyverno CLI tests* (beta) — offline CEL evaluation that could run without a cluster, but packaged into gluon for practical CI reasons
   - *CEL policy chainsaw integration tests* (beta) — live admission tests against deployed CEL policies (VPol/MPol/GPol)

   Gluon executes scripts in lexicographic filename order with `set -e` — any failure stops the pod. Use filename prefixes to control execution order.

## Test values

CI layers the Big Bang umbrella's `tests/test-values.yaml` under this repo's `tests/test-values.yaml`. Many CPol tests depend on policy parameters (allowed paths, allowed capabilities, etc.) that only the umbrella provides — a bare `helm install` will see test failures that don't reproduce in CI. Use [`docs/dev-overrides.yaml`](dev-overrides.yaml) to get equivalent coverage locally:

```shell
helm upgrade -i kyverno-policies chart/ -n kyverno -f docs/dev-overrides.yaml
helm test kyverno-policies -n kyverno --timeout 10m
```

Test scripts toggle `validationFailureAction` on CPols/VPols via `kubectl patch` in `_helpers.sh`. After a test run, `kubectl patch` leaves a competing field-manager entry that blocks the next bare `helm upgrade`. Fix: pass `--force-conflicts` on the next `helm upgrade`, or use the Flux-based install mode (see below) which applies `--force` by default.

Set `validationFailureAction: Audit` for all validation policies under test. This lets Kyverno capture all violations in a policy report rather than stopping at the first one.

## CPol tests (legacy)

The `05_test-cpols.sh` script tests ClusterPolicies by patching each to Enforce one at a time, applying test manifests from `chart/tests/manifests/`, and checking admission results. Test manifests use `kyverno-policies-bbtest/*` annotations to declare expected outcomes — see any manifest file for the schema (e.g. `chart/tests/manifests/disallow-privileged-containers.yaml`).

These tests stay as long as the CPols they cover exist. Remove each test only when its CPol is deleted.

## VPol / CEL policy tests

ValidatingPolicy templates have three layers of testing, each catching different classes of bugs:

1. **Helm unit tests** — Fast, offline. Verify template rendering (values, helpers, guards, YAML structure). Run via `helm unittest`.
2. **Kyverno CLI tests** — Offline CEL evaluation. Verify that CEL expressions admit good resources and reject bad ones. No cluster needed, runs in ~2s.
3. **Chainsaw integration tests** — Live cluster. Apply the VPol, patch to Deny, create good/bad resources, verify admission webhook behavior end-to-end. Chainsaw runs all policies in parallel.

The kyverno CLI test is the fastest gate — if CEL expressions are broken, it fails before chainsaw burns time on live admission.

### Test fixture conventions

- Fixtures live in `chart/tests/vpol/<policy-name>/kyverno-test/` and `chainsaw-test/`.
- Fixtures are **plain YAML, not Helm templates** — they're packaged into a ConfigMap verbatim.
- **Chainsaw fixtures must use `registry1.dso.mil` images** (e.g. `ubi9-micro`) to pass `restrict-image-registries` in CI. Kyverno CLI fixtures use dummy image names since they never pull.

