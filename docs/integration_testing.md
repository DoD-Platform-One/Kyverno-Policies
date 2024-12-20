# Kyverno Policy Integration Tests

To test policies on the packages in Big Bang, there are likely several paths to doing so. A few examples are outlined below.

## Big Bang Pipeline

 One easy, albeit time consuming method is to simply utilize the `bigbang` repo pipeline for `all-packages`. This is a minimal hassle method because it uses the current Big Bang baseline automatically and handles all the cluster resources.

To test in the big bang pipeline:

1. Create a branch in the big bang repo

```bash
git checkout -b <kyverno policy test branch>
```

2. Modify the tests/test-values.yaml with the policy you are testing (note, test in 'Audit' so all violations can be captured)

```yaml
kyvernoPolicies:
    policies:
        <policy-name>:
            enabled: true
            validationFailureAction: Audit
```

3. Commit and push changes, start an MR off the branch to kick off the pipeline
    - **Ensure MR is marked `Draft` and denoted as a test**
    - Select label `all-packages` to ensure all packages and addons are tested

4. Sit back, relax, write some docs, etc. while the pipeline runs

5. After it completes, download the artifacts and open the `events.txt` to identfy all PolicyViolations

```bash
cat events.txt | grep "PolicyViolation" | grep "clusterpolicy/<policy-title>" | sort -u >> policy_violations_<policy-title>.txt
```

## Local Validation Testing

An alternative to using a Big Bang MR pipeline is to use the script provided at `./docs/tools/bb-validate.sh`. The script should be used as a quick and easy way to validate packages against a Kyverno policy, with some limitations.

A caveat of this script is that is does not validate resources that are created or managed by operators. The script will warn when a package that you are validating relies upon or contains resources that are managed by operators.

This script is not meant to replace the Big Bang repo pipeline integration tests. It is intended to assist developers of this package when investigating package violations or enabling new policies.

```console
$ ./docs/tools/bb-validate.sh -h

BigBang Package Validator for Kyverno Policies. Intended to assist developers when investigating Kyverno policy violations for BigBang packages.
Validates packages from the latest BigBang release against the specified Kyverno policy.

Requires the following environment vars to be set: GITLAB_TOKEN, KUBECONFIG, REGISTRY1_USER, REGISTRY1_PASS
Note: This tool assumes that you have already run the 'k3d-dev.sh' script with nothing else installed afterwards, including flux and BigBang.

Usage: ./bb_validate.sh [-p <policy>][-c <chart>][-h]

Example: Lint a specific chart against a specific policy:
        ./bb_validate.sh -p require-image-signature -c elasticsearch
```

## Policy Reports

The `PolicyReport` object is a namespaced object managed by Kyverno that contains validation results of objects in that namespace against Kyverno policies that apply to that namespace. This object is helpful when investigating the validation failuires for resources that are managed by operators. You can read more about the `PolicyReport` object [here](https://kyverno.io/docs/policy-reports/).

If you were to install Big Bang in a dev environment using the same values as the pipeline method mentioned earlier on this page, you could retrieve `PolicyReport` objects as such:

```bash
#Retrieve PolicyReports containing Failures in a given namespace
$ kubectl get polr -n kiali | awk '$5 > 0 {print $0}'
NAME                                   KIND         NAME                                    PASS   FAIL   WARN   ERROR   SKIP   AGE
5d9f2a9e-eada-4c25-b7bf-c0f75f66d9c3   Deployment   kiali-kiali-operator                    0      1      0      0       0      9m39s
75d4b591-30f6-4dbd-9667-7a9a593a5639   Pod          kiali-kiali-operator-794ddf9585-lcspg   0      1      0      0       0      9m39s
```
