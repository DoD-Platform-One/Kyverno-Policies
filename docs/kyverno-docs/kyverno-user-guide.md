# Policy management

## The need for policy management

Policies describe rules that can be implemented org wide and help guide and constrain behaviors that cut across various concerns like security, compliance, auditing, and governance.  Policies provide a framework for these desired outcomes and can be enforced as declarative rules.  Kubernetes, through its highly extensible API, allows for these policies to be run as part of the control plane through dynamic admission control.  Kubernetes has a reference model for cloud native security called the "4Cs" (cloud, cluster, container, and code).  Policy management in this context deals with the cluster and container, with cloud and code being out of scope.  A more robust discussion on policy management by the CNCF can be found [here](https://github.com/kubernetes/sig-security/blob/main/sig-security-docs/papers/policy/CNCF_Kubernetes_Policy_Management_WhitePaper_v1.pdf).

The goal of this document is to provide a quickstart guide on adopting and implementing Kyverno policies to provide a security baseline.  This is a prescriptive suggestion on implementing a base security posture using Kyverno policies.  While various environments may have different security and compliance requirements, these suggestions will serve as a security platform upon which an iterative, incremental approach can enable teams get to their desired target state.

This document does not address Kyverno architecture and how it works.  For more architectural information please refer to this [link](https://repo1.dso.mil/big-bang/apps/sandbox/kyverno/-/blob/main/docs/overview.md).  Also, to migrate from gatekeeper to Kyverno you can refer to this [migration guide](https://repo1.dso.mil/big-bang/apps/sandbox/kyverno/-/blob/main/docs/gatekeeper.md).

## What are policies

A Kyverno policy is simply a collection of rules.  These rules are enforced by Kyverno - a policy engine for Kubernetes - using a kubernetes native concept called [admission control](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/).  Policies contain a match and an optional exclude declaration that can be either scoped to a namespace or cluster wide.  This [link](https://kyverno.io/docs/kyverno-policies/) provides more insight into the anatomy of a policy.

## Bigbang implementation of policies

Bigbang provides a helm chart as a wrapper for the upstream [Kyverno Policy library](https://kyverno.io/policies/?policytypes=Pod%2520Security%2520Admission%2BSecurity%2Bvalidate).  Not all of the library policies are implemented in Big Bang.  However, additional policies can be added ad-hoc through the Helm chart.  The description for the Big Bang policies can be found [here](https://repo1.dso.mil/big-bang/apps/sandbox/kyverno-policies/-/blob/main/docs/policies.md).

## Notional security posture

A starting point for security and governance can be tricky because there are a lot of controls and needs which need to be satisfied.  A good way to start would be to have a baseline default posture and then iteratively improve it as additional compliance and security needs arise.  While it widely understood that there is no "one size fits all" default , having a notional default is always advised.

One approach is to start with enforcing the [Kubernetes Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) or [CIS Benchmark for Kubernetes](https://www.cisecurity.org/benchmark/kubernetes).  The following table shows which policy would be applied under each standard.

| Policy | Pod Security Standard | CIS Benchmark |
|--|--|--|
| disallow-host-namespaces | X | X |
| disallow-namespaces | | X |
| disallow-privilege-escalation | X | X |
| disallow-privileged-containers | X | X |
| disallow-rbac-on-default-serviceaccounts | | X |
| disallow-selinux-options<BR>restrict-selinux-type<BR>(RedHat Derivatives) | X | |
| require-drop-all-capabilities<BR>restrict-capabilities | X | X |
| require-non-root-group | X | |
| require-non-root-user | X | X |
| restrict-apparmor<BR>(Debian Derivatives) | X | |
| restrict-host-ports | X | |
| restrict-proc-mount | X | |
| restrict-seccomp | X | X |
| restrict-sysctls | X | |
| restrict-volume-types | X | |
| update-token-automount | | X |

Additionally, the [CNCF recommends some best practices](https://www.cncf.io/wp-content/uploads/2020/08/CNCF-Webinar-Kyverno-1.pdf) that can be implemented with the following policies:

- disallow-image-tags
- require-cpu-limit
- require-memory-limit
- require-probes
- require-ro-rootfs
- restrict-image-registries

A list of all the policies listed and their definitions can be found [here](https://repo1.dso.mil/big-bang/apps/sandbox/kyverno-policies/-/blob/main/docs/policies.md).  Once you have the base security policies above implemented, it is recommended that you browse the [policies provided by Big Bang](https://repo1.dso.mil/big-bang/apps/sandbox/kyverno-policies/-/blob/main/docs/policies.md) and the [Kyverno policy library](https://kyverno.io/policies/?policytypes=Pod%2520Security%2520Admission%2BSecurity%2Bvalidate) for additional policies to add to your cluster.

## Implementing these policies

To implement these policies in Bigbang would require modifying the [values.yaml](https://repo1.dso.mil/big-bang/apps/sandbox/kyverno-policies/-/blob/main/chart/values.yaml) file in the [Kyverno policies chart](https://repo1.dso.mil/big-bang/apps/sandbox/kyverno-policies/-/tree/main/chart).  Directions on how to toggle the policies are shown in the values.yaml file.  The sample policy shows you how.

```yaml
policies:
  # Keep policies in alphabetical order and name them the same as the .yaml file to help with configuration and troubleshooting

  # -- Sample policy showing values that can be added to any policy
  sample:
    # -- Controls policy deployment
    enabled: false
    # -- Controls if a validation policy rule failure should disallow (enforce) or allow (audit) the admission
    validationFailureAction: audit # or enforce
    # -- Specifies the maximum time in seconds allowed to apply this policy. Default is 10. Range is 1 to 30.
    webhookTimeoutSeconds: ""
    # -- Defines when this policy's rules should be applied.  This completely overrides any default matches.
    match: {}
    # -- Defines when this policy's rules should not be applied.  This completely overrides any default excludes.
    exclude: {}
    # -- Policy specific parameters that are added to the configMap for the policy rules
    parameters: {}
```

> In Big Bang, you would set these values using `kyverno-policies.values.policies`

## Workflow on adoption

As indicated earlier, this document provides a starting point on how to adopt Kyverno policies for cluster security and should iteratively be improved upon after proper testing and validation.

A strategy to adopt is

- Set timeline for implementation.
- Start from audit and eventually get to enforce once comfortable with the impact and remediation of violations.
- Methodically document any policy exceptions in the values file to make reviews and audits quicker.
- Have periodic reviews to add or modify policies as security and compliance needs evolve.

## Additional resources for learning

These are some helpful links in gathering more information about Kyverno

- [Kubernetes-Native Policy Management With Kyverno](https://www.youtube.com/watch?v=DREjzfTzNpA)
- [Kyverno in Production (use cases and best practices)](https://www.youtube.com/watch?v=QR-iBeh9Vy0)
- [Replacing PSPs? Keep Bad Pods out of your cluster using Kyverno!- Shuting Zhao, Nirmata](https://www.youtube.com/watch?v=AmJUFH7n33c&t=27s)
- [Policy As Code on Kubernetes With Kyverno](https://betterprogramming.pub/policy-as-code-on-kubernetes-with-kyverno-b144749f144)
