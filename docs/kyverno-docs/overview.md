# Kyverno

[Kyverno](https://kyverno.io) is a policy management tool for Kubernetes.  This repo contains an enhanced Helm chart for deploying Kyverno with [Big Bang](https://repo1.dso.mil/platform-one/big-bang/bigbang).  See the [Helm chart README.md](../chart/README.md) for more information on using the chart.

Big Bang will also deploy the [Kyverno Policies Helm chart](https://repo1.dso.mil/platform-one/big-bang/apps/sandbox/kyverno-policies) to deploy a collection of default policies for Kyverno.

## Introduction to Kyverno

Kyverno is Kubernetes native policy management engine. What that means is that policy management rules are defined using Kubernetes resources. As such, there is no need to learn a new language. This is a big plus compared to Gatekeeper, that requires REGO expertise.  REGO not only has a steep learning curve but also needs thorough testing, as the cryptic syntax can introduced side effects that are not obvious by looking at the code.

Kyverno allows cluster administrators to manage environment specific configurations independently of workload configurations and enforce configuration best practices for their clusters. Kyverno can be used to scan existing workloads for best practices, or can be used to enforce best practices by blocking or mutating API requests.

## How Kyverno works

Kyverno runs as a [dynamic admission controller](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/) in a Kubernetes cluster. Kyverno receives validating and mutating admission webhook HTTP callbacks from the kube-apiserver and applies matching policies to return results that enforce admission policies or reject requests.

Kyverno policies can match resources using the resource kind, name, and label selectors. Wildcards are supported in names.

Mutating policies can be written as overlays (similar to [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#bases-and-overlays)) or as a [RFC 6902 JSON](http://jsonpatch.com/) Patch. Validating policies also use an overlay style syntax, with support for pattern matching and conditional (if-then-else) processing.

Policy enforcement is captured using Kubernetes events. Kyverno also reports policy violations for existing resources.

## Quick Start

```
# Add the Helm repository
helm repo add kyverno https://kyverno.github.io/kyverno/

# Scan your Helm repositories to fetch the latest available charts.
helm repo update

# Install the Kyverno Helm chart into a new namespace called "kyverno"
helm -n kyverno --create-namespace install kyverno kyverno/kyverno

# Verify that Kyverno pods are running
kubectl -n kyverno get pods
```

Create a Policy Resource as shown below. The validation rule is implemented using a regex expression match against te tier label in metadata section of Pod spec. Validation fails if the label is missing.

When this is applied in the kubernetes cluster, the Kyverno custom controller that is watching ClusterPolicy objects updates its configuration to check for the label tier during the creation request for a new Pod. If the label is missing, request is denied by the admission control.

```
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-tier-label
spec:
  validationFailureAction: enforce
  rules:
  - name: check-for-label
    match:
      resources:
        kinds:
        - Pod
    validate:
      message: "label 'tier' is required"
      pattern:
        metadata:
          labels:
            tier: "?*"
```

Verify the require-tier-label ClusterPolicy resource as follows:

kubectl describe cpol require-tier-label

```
  rules:
  - match:
      resources:
        kinds:
        - Pod
    name: check-for-label
    validate:
      message: label 'tier' is required
      pattern:
        metadata:
          labels:
  - match:
      resources:
        kinds:
        - DaemonSet
        - Deployment
        - Job
        - StatefulSet
    name: autogen-check-for-label
    validate:
      message: label 'tier' is required
      pattern:
        spec:
          template:
            metadata:
              labels:
                tier: ?*

```

Note that Kyverno has automatically included DaemonSet, Deployment, StatefulSet and Job in addition to Pod to apply the policy, as these resources also create a Pod.

Try to create a Pod as follows:

```
kubectl run nginx --image=nginx:latest
```

The request is denied with the following message as expected because the label tier is missing.

```
Error from server: admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/default/nginx was blocked due to the following policies

require-tier-label:
  check-for-label: 'validation error: label ''tier'' is required. Rule check-for-label
    failed at path /metadata/labels/tier/'
```

Now try to create the Pod as follows and the request is successful:

```
kubectl run nginx --image=nginx:latest --labels tier=web
```

## Notes for Uninstall

To fully cleanup Kyverno, you should delete the webhooks in addition to uninstalling the chart:

```shell
# Uninstall chart
helm uninstall kyverno chart/

# Clean up webhooks
kubectl delete mutatingwebhookconfigurations kyverno-policy-mutating-webhook-cfg kyverno-resource-mutating-webhook-cfg kyverno-verify-mutating-webhook-cfg

kubectl delete validatingwebhookconfigurations kyverno-policy-validating-webhook-cfg kyverno-resource-validating-webhook-cfg
```

## Resources

[Kyverno Official Documentation
](https://kyverno.io/docs/)

[Video Tutorial - Policy Management with Kyverno
](https://www.youtube.com/watch?v=ZrbJB2KgFAE)

[Gatekeeper Migration Guide](./gatekeeper.md)

[Kyverno Chart](../chart/README.md)
