# CEL Migration: Policy Inventory

Tracks issue [#204](https://repo1.dso.mil/big-bang/product/packages/kyverno-policies/-/issues/204), Step 1.

This table inventories every policy defined in `chart/values.yaml` with the fields needed to plan a migration from Kyverno `ClusterPolicy` to CEL-based policy types.

### Migration landscape (as of February 2026)

**Kyverno 1.14–1.17** introduced dedicated CEL-based CRDs to replace `ClusterPolicy` for each rule type:

| Kyverno CRD | Replaces | Status in 1.17 |
|---|---|---|
| `ValidatingPolicy` | `validate` rules | v1 |
| `MutatingPolicy` | `mutate` rules | v1 |
| `GeneratingPolicy` | `generate` rules | v1 |
| `ImageValidatingPolicy` | `verifyImages` rules | v1 |
| `DeletingPolicy` | _(new)_ | v1 |

CEL policy types are v1 in Kyverno 1.17, with GA targeted for 1.18. `ClusterPolicy` remains supported for backward compatibility.

Source data:

- **Name, Type**: [`docs/policies.md`](../policies.md)
- **Default enabled, Default enforcement**: `chart/values.yaml` (enabled = `true` in values; enforcement = `validationFailureAction`)

## Inventory

| Name | Type | Default enabled | Default enforcement | CEL migration target |
|------|------|:---:|:---:|---|
| [`block-ephemeral-containers`](../../chart/templates/block-ephemeral-containers.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`disallow-annotations`](../../chart/templates/disallow-annotations.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`disallow-auto-mount-service-account-token`](../../chart/templates/disallow-auto-mount-service-account-token.yaml) | Validate | yes | Audit | `ValidatingPolicy` |
| [`disallow-deprecated-apis`](../../chart/templates/disallow-deprecated-apis.yaml) | Validate | yes | Audit | `ValidatingPolicy` |
| [`disallow-host-namespaces`](../../chart/templates/disallow-host-namespaces.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`disallow-image-tags`](../../chart/templates/disallow-image-tags.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`disallow-istio-injection-bypass`](../../chart/templates/disallow-istio-injection-bypass.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`disallow-labels`](../../chart/templates/disallow-labels.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`disallow-namespaces`](../../chart/templates/disallow-namespaces.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`disallow-nodeport-services`](../../chart/templates/disallow-nodeport-services.yaml) | Validate | yes | Audit | `ValidatingPolicy` |
| [`disallow-pod-exec`](../../chart/templates/disallow-pod-exec.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`disallow-privilege-escalation`](../../chart/templates/disallow-privilege-escalation.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`disallow-privileged-containers`](../../chart/templates/disallow-privileged-containers.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`disallow-rbac-on-default-serviceaccounts`](../../chart/templates/disallow-rbac-on-default-serviceaccounts.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`disallow-selinux-options`](../../chart/templates/disallow-selinux-options.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`disallow-tolerations`](../../chart/templates/disallow-tolerations.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`require-annotations`](../../chart/templates/require-annotations.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`require-cpu-limit`](../../chart/templates/require-cpu-limit.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`require-drop-all-capabilities`](../../chart/templates/require-drop-all-capabilities.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`require-istio-on-namespaces`](../../chart/templates/require-istio-on-namespaces.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`require-labels`](../../chart/templates/require-labels.yaml) | Validate | yes | Audit | `ValidatingPolicy` |
| [`require-memory-limit`](../../chart/templates/require-memory-limit.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`require-non-root-group`](../../chart/templates/require-non-root-group.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`require-non-root-user`](../../chart/templates/require-non-root-user.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`require-probes`](../../chart/templates/require-probes.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`require-requests-equal-limits`](../../chart/templates/require-requests-equal-limits.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`require-ro-rootfs`](../../chart/templates/require-ro-rootfs.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`restrict-apparmor`](../../chart/templates/restrict-apparmor.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`restrict-capabilities`](../../chart/templates/restrict-capabilities.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`restrict-external-ips`](../../chart/templates/restrict-external-ips.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`restrict-external-names`](../../chart/templates/restrict-external-names.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`restrict-group-id`](../../chart/templates/restrict-group-id.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`restrict-host-path-mount`](../../chart/templates/restrict-host-path-mount.yaml) | Validate | yes | Audit | `ValidatingPolicy` |
| [`restrict-host-path-mount-pv`](../../chart/templates/restrict-host-path-mount-pv.yaml) | Validate | yes | Audit | `ValidatingPolicy` |
| [`restrict-host-path-write`](../../chart/templates/restrict-host-path-write.yaml) | Validate | yes | Audit | `ValidatingPolicy` |
| [`restrict-host-ports`](../../chart/templates/restrict-host-ports.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`restrict-image-registries`](../../chart/templates/restrict-image-registries.yaml) | Validate | yes | Audit | `ValidatingPolicy` |
| [`restrict-proc-mount`](../../chart/templates/restrict-proc-mount.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`restrict-seccomp`](../../chart/templates/restrict-seccomp.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`restrict-selinux-type`](../../chart/templates/restrict-selinux-type.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`restrict-sysctls`](../../chart/templates/restrict-sysctls.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`restrict-user-id`](../../chart/templates/restrict-user-id.yaml) | Validate | no | Audit | `ValidatingPolicy` |
| [`restrict-volume-types`](../../chart/templates/restrict-volume-types.yaml) | Validate | yes | Enforce | `ValidatingPolicy` |
| [`add-default-capability-drop`](../../chart/templates/add-default-capability-drop.yaml) | Mutate | yes | Enforce | `MutatingPolicy` |
| [`add-default-securitycontext`](../../chart/templates/add-default-securitycontext.yaml) | Mutate | yes | Enforce | `MutatingPolicy` |
| [`update-automountserviceaccounttokens`](../../chart/templates/update-automountserviceaccounttokens.yaml) | Mutate | no | n/a | `MutatingPolicy` |
| [`update-automountserviceaccounttokens-default`](../../chart/templates/update-automountserviceaccounttokens-default.yaml) | Mutate | no | n/a | `MutatingPolicy` |
| [`update-image-pull-policy`](../../chart/templates/update-image-pull-policy.yaml) | Mutate | no | n/a | `MutatingPolicy` |
| [`update-image-registry`](../../chart/templates/update-image-registry.yaml) | Mutate | no | n/a | `MutatingPolicy` |
| [`clone-configs`](../../chart/templates/clone-configs.yaml) | Generate | no | n/a | `GeneratingPolicy` |
| [`require-image-signature`](../../chart/templates/require-image-signature.yaml) | VerifyImage | yes | Enforce | `ImageValidatingPolicy` |

**Totals:** 51 policies — 43 `ValidatingPolicy`, 6 `MutatingPolicy`, 1 `GeneratingPolicy`, 1 `ImageValidatingPolicy`

## Notes

- The `sample` policy in `values.yaml` is a template placeholder and is excluded from this inventory.
- Two policies in [`docs/policies.md`](../policies.md) (`exception-require-non-root-group`, `exception-require-non-root-user`) are not present in `values.yaml` and are excluded. These are helper exception policies that augment `require-non-root-group` and `require-non-root-user` respectively and should be reviewed for consolidation during migration.
- BB currently bakes policy exceptions into the `exclude` block of each policy template (populated from Big Bang umbrella values). The Product Improvement team (~"team::Product Improvement" ) is planning to externalize these as standalone Kyverno [`PolicyException`](https://kyverno.io/docs/guides/exceptions/) resources via the `bb-common` Helm library chart (see [Epic #609: Leverage bb-common for Kyverno PolicyExceptions](https://repo1.dso.mil/groups/big-bang/-/epics/609)). That work would simplify our policy templates before or during the CEL migration. Step 3 of #204 will audit baked-in exceptions per policy to inform both efforts.
- Steps 2–5 of [#204](https://repo1.dso.mil/big-bang/product/packages/kyverno-policies/-/issues/204) will add columns for upstream mapping, BB customizations, migration blockers, and readiness classification.
