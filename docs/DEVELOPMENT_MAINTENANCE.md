# How to update Kyverno Policies
## Update dependencies

1. Create a development branch and merge request from the Gitlab issue or use the existing `renovate/ironbank` branch and existing MR created by Renovate.

2. Kyervno Policies only uses a Gluon dependency. Validate it is on the latest version in `chart/Chart.yaml` then run `helm dependency update chart`.

3. Append `-bb.x` to the `version` in `chart/Chart.yaml`.

4. Update `CHANGELOG.md` adding an entry for the new version and noting all changes (Example: `Updated kubectl from x.x.x to x.x.x`).

5. Generate the `README.md` updates by following the [guide in gluon](https://repo1.dso.mil/platform-one/big-bang/apps/library-charts/gluon/-/blob/master/docs/bb-package-readme.md).

6. Open an MR in "Draft" status ( or the Renovate created MR ) and validate that CI passes. This will perform a number of smoke tests against the package, but it is good to manually deploy to test some things that CI doesn't. Follow the steps below for manual testing.

7. Once all manual testing is complete take your MR out of "Draft" status and add the review label on both the Issue and MR. 

## Testing with Big Bang

> NOTE: For these testing steps it is good to do them on both a clean install and an upgrade. For clean install, point kyvernoPolicies to your branch. For an upgrade do an install with kyvernoPolicies pointing to the latest tag, then perform a helm upgrade with kyverno pointing to your branch.

Deploy Kyverno Policies using the Helm chart ( pointing to your branch )

```yaml
    kyvernoPolicies:
      git:
        tag: null
        branch: "renovate/ironbank" # Or your branch
      enabled: true
```

You will want to install with:
- Kyverno, Kyverno-Policies, and Kyverno-Reporter enabled
- Istio enabled
- Monitoring enabled

Checking Prometheus for Kyverno dashboards
- Login to Prometheus, validate under `Status` -> `Targets` that all kyverno targets are showing as up
- Login to Grafana, then navigate to the Kyverno daskboard ( Dashboards > Browse > Kyverno ) and validate that the dashboard displays policy data

> 📌 __NOTE__: if using MacOS make sure that you have gnu sed installed and add it to your PATH variable [GNU SED Instructions](https://gist.github.com/andre3k1/e3a1a7133fded5de5a9ee99c87c6fa0d)
- [ ] Test secret sync in new namespace
    ```Shell
    # create secret in kyverno NS
    kubectl create secret generic \
      -n kyverno kyverno-bbtest-secret \
      --from-literal=username='username' \
      --from-literal=password='password'

    # Create Kyverno Policy
    kubectl apply -f https://repo1.dso.mil/big-bang/product/packages/kyverno/-/raw/main/chart/tests/manifests/sync-secrets.yaml

    # Wait until the policy shows as ready before proceeding
    kubectl get clusterpolicy sync-secrets

    # Create a namespace with the correct label (essentially we are dry-running a namespace creation to get the yaml, adding the label, then applying)
    kubectl create namespace kyverno-bbtest --dry-run=client -o yaml | sed '/^metadata:/a\ \ labels: {"kubernetes.io/metadata.name": "kyverno-bbtest"}' | kubectl apply -f -

    # Check for the secret that should be synced - if it exists this test is successful
    kubectl get secrets kyverno-bbtest-secret -n kyverno-bbtest
    ```
- [ ] Delete the test resources
    ```shell
    # If above is successful, delete test resources
    kubectl delete -f https://repo1.dso.mil/big-bang/product/packages/kyverno/-/raw/main/chart/tests/manifests/sync-secrets.yaml
    kubectl delete secret kyverno-bbtest-secret -n kyverno
    kubectl delete ns kyverno-bbtest
    ```
