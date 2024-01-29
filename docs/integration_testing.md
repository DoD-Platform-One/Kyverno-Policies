# Kyverno Policy Integration Tests

To test policies on the packages in Big Bang, there are likely several paths to doing so. One easy, albeit time consuming method is to simply utilize the `bigbang` repo pipeline for `all-packages`. This is a minimal hassle method because it uses the current Big Bang baseline automatically and handles all the cluster resources.

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