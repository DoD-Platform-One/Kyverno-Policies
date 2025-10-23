This document provides information about an effort to harden automatic mounting of ServiceAccount tokens.

# ServiceAccount Token Background

When Pods contact the Kubernetes API server, Pods authenticate as a particular ServiceAccount.

They authenticate using an API token at `/var/run/secrets/kubernetes.io/serviceaccount/token`. This API token is automatically mounted at Pod runtime via the `kubelet`.

By default, this behavior is true for all Pods - even if you don’t specify a ServiceAccount for your Pod. If unspecified, the Pod will use the `default` ServiceAccount - a ServiceAccount present in every Kubernetes namespace.

More information: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/>

# Epic Background

In theory, an attacker could use that API token to pivot across the Kubernetes cluster and exploit more resources.

That is why this tenant should be followed: only Pods that require access to the Kubernetes API to function should have an API token automounted. Otherwise, the token should not be automounted, since that would be an unnecessary security risk.

The token automounting behavior can be configured with the option `automountServiceAccountToken:` at the ServiceAccount level:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-sa
automountServiceAccountToken: false
...
```

Or at the pod-spec level:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: my-sa
  automountServiceAccountToken: true
  ...
```

# Kyverno Policy Violation

To better account for the potential violations of this security standard, a [Kyverno policy](https://repo1.dso.mil/big-bang/product/packages/kyverno-policies/-/blob/main/chart/templates/disallow-auto-mount-service-account-token.yaml?ref_type=heads) will audit a Kubernetes event when an insecure ServiceAccount or Pod is detected.

A ServiceAccount violation event may look like this:

```
43m         Warning   PolicyViolation         serviceaccount/tempo-tempo                    policy disallow-auto-mount-service-account-token/automount-service-accounts fail: validation error: Automount Kubernetes API Credentials isn't turned off. The field automountServiceAccountToken  must be set to false. rule automount-service-accounts failed at path /automountServiceAccountToken/
```

And a Pod violation event may look like this:

```
43m         Warning   PolicyViolation         pod/tempo-tempo-0                             policy disallow-auto-mount-service-account-token/automount-pods fail: validation error: Automount Kubernetes API Credentials is explicitly turned on. The field spec.automountServiceAccountToken  must be undefined or set to false. rule automount-pods failed at path /spec/automountServiceAccountToken/
```

# Mitigating Violations

To be rid of the Kyverno policy violations, package hardening must take place.

The general process of package hardening is this: disable automatic token mounting for all ServiceAccounts (with `automountServiceAccountToken: false`), and only enable it for Pods that truly require access to the Kubernetes API (with `automountServiceAccountToken: true`). Said Pods can then be given an Exception to the Kyverno policy.

This process can be completed “manually”, by modifying package templates with `automountServiceAccountToken: true` or `false` and writing policy exceptions yourself.

However, to streamline and consolidate the process, the [mutating Kyverno Policy](https://repo1.dso.mil/big-bang/product/packages/kyverno-policies/-/blob/main/chart/templates/update-automountserviceaccounttokens.yaml?ref_type=heads) should be used. This policy is capable of hardening all ServiceAccounts in a namespace and creating Pod exceptions via a simple list.

The mutator should be configured in the Big Bang umbrella chart repository, [where the kyverno-policies values are defined](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/chart/templates/kyverno-policies/values.yaml?ref_type=heads).

## Example Mutator Usage

```yaml
  update-automountserviceaccounttokens:
    enabled: true
    namespaces:
      - namespace: argocd
        pods:
        # application-controller pods interact with secrets, configmaps, events, and Argo CRDs 
        # More details in argocd/chart/templates/argocd-application-controller/role.yaml
        - argocd-argocd-application-controller-*
       # dex pods interact with secrets and configmaps
        # More details in argocd/chart/templates/dex/role.yaml
        - argocd-argocd-dex-server-*
```

```
NOTE
The mutator supports a serviceAccounts array, in case you want to explicitly harden ServiceAccounts. 

In this example, that array is missing - this enables the wildcard feature of the mutator. This means that every ServiceAccount in the namespace will be hardened, not just those explicitly defined.

This is the recommended method of configuring the mutator, as upstream changes may break explicit hardening of ServiceAccounts.
```

```
Note: It is a good rule of thumb to quickly document justification for the Pod exception, in the form of a comment.
```

The real effort here is determining if a Pod truly needs access to the API. There is no silver bullet here, as this requires some intimate knowledge of the Package itself and how it functions.

Here are a few tips/notes, however:

* If a Pod specification uses a dedicated ServiceAccount, dig into the manifests and see if there are Roles and RoleBindings that “attach” to that ServiceAccount. If there are, then we can be sure that the Pod communicates with the API, and thus requires an API token, otherwise the Role would be superfluous. Upstream package developers may leave dangling/superfluous Roles, but this is the exception, not the rule.
* It is helpful to manually test the package with no Pod exceptions (with all ServiceAccounts hardened) and see what breaks. If any functionality is lost, then that Pod probably needs an exception.
* Occasionally, in the upstream package templates, pods will explicitly have `automountServiceAccountToken: true` set. If that is the case, then the package maintainers probably have a reason to explicitly set that, so it may be a safe assumption that the Pod needs access to the API. That being said, there have been a few instances where maintainers explicitly set this and the Pod doesn’t truly require it - it may have just been negligence. Trust but verify.

### Default ServiceAccount

In new Packages, you may see this violation:

```
43m         Warning   PolicyViolation         serviceaccount/default                    policy disallow-auto-mount-service-account-token/automount-service-accounts fail: validation error: Automount Kubernetes API Credentials isn't turned off. The field automountServiceAccountToken  must be set to false. rule automount-service-accounts failed at path /automountServiceAccountToken/
```

As stated previously, the `default` ServiceAccount is present in every namespace. It is used as a fallback when a Pod does not explicitly specify a ServiceAccount in their manifest.

There is very little use case for the default ServiceAccount having access to the API, and as such, this ServiceAccount should always be hardened.

A separate mutator exists for hardening this ServiceAccount (a separate policy was needed due to the fact that `default` needed to be updated in place, rather than on creation, like the original mutator).

Example usage:

```yaml
 update-automountserviceaccounttokens-default:
    enabled: true
    namespaces:
      - argocd
```

### Package Documentation

One drawback of this mutator methodology is that this hardening has potential for breakage (and thus, package codeowners should be aware of its existence), but the actual hardening exists in another repository (BB umbrella).

Some documentation in `DEVELOPMENT_MAINTENANCE.md` can help mitigate this by increasing awareness of the link between this policy-based hardening and the package.

A snippet like below should be added to the `DEVELOPMENT_MAINTENANCE.md` (or other suitable location) of the hardened package:

```
The mutating Kyverno policy named `update-automountserviceaccounttokens` is leveraged to harden all ServiceAccounts in this package with `automountServiceAccountToken: false`. This policy is configured by namespace in the Big Bang umbrella chart repository at [chart/templates/kyverno-policies/values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/chart/templates/kyverno-policies/values.yaml?ref_type=heads).

This policy revokes access to the K8s API for Pods utilizing said ServiceAccounts. If a Pod truly requires access to the K8s API (for app functionality), the Pod is added to the `pods:` array of the same mutating policy. This grants the Pod access to the API, and creates a Kyverno PolicyException to prevent an alert.
```

# Example MRs

This is the MR for hardening the package via the mutator: <https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/3466>

And this is the MR for updating package documentation: <https://repo1.dso.mil/big-bang/product/packages/argocd/-/merge_requests/190>
