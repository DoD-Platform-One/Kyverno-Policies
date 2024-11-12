# Migration from Gatekeeper to Kyverno

Refer to the following document for the policies implemented in Big Bang under Gatekeeper and the corresponding policy in Kyverno:

[Kyverno Policies vs. Gatekeeper Policies in Big Bang
](https://repo1.dso.mil/platform-one/big-bang/apps/sandbox/kyverno-policies/-/blob/main/docs/gatekeeper.md)

Kyverno can coexist with Gatekeeper as both these mechanisms extend admission control independent of each other. However, it must be noted that for each validation hook that is introduced into the admission control, it takes extra time to process the request by kube api server.  As such, any performance degradation must be considered when running both Gatekeeper and Kyverno in a Kubernetes cluster.

If Gatekeeper is already running in the cluster and the intent is to replace it with Kyverno, it is recommended that Kyverno is enabled and Kyverno policies are installed before proceeding with Gatekeeper uninstall. This two pass approach has been tested to work reliably. Enabling Kyverno and disabling Gatekeeper during the same Helm upgrade often fails with retries exhausted error, especially in resource constrained environments, like k3d.

## Enable Kyverno

Apply helm upgrade using the following BigBang Helm Chart values:

```
kyverno:
  enabled: true

kyvernopolicies:
  enabled: true
```

## Verify that Kyverno pods are running

kubectl -n kyverno get pods

## Verify that Kyverno policies are ready

kubectl -n kyverno get cpol

Ensure that all the policies listed by the command are ready i.e. all the policies have value true for the READY column.

## Disable Gatekeeper

Apply helm upgrade using the following BigBang Helm Chart values:

```
gatekeeper:
  enabled: false

clusterAuditor:
  enabled: false
```

Note that when gatekeeper is disabled using the helm upgrade process, the Gatekeeper webhook (gatekeeper-validating-webhook-configuration), Gatekeeper CRDs, Gatekeeper Constraint CRDs along with any constraint resources are also removed automatically.
