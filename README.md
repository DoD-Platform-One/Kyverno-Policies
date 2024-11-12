<!-- Warning: Do not manually edit this file. See notes on gluon + helm-docs at the end of this file for more information. -->
# kyverno-policies

![Version: 3.2.6-bb.1](https://img.shields.io/badge/Version-3.2.6--bb.1-informational?style=flat-square) ![AppVersion: v1.12.6](https://img.shields.io/badge/AppVersion-v1.12.6-informational?style=flat-square)

Collection of Kyverno security and best-practice policies for Kyverno

## Upstream References

- <https://kyverno.io/policies/>

- <https://github.com/kyverno/policies>

## Upstream Release Notes

- [Find our upstream chart's CHANGELOG here](https://repo1.dso.mil/big-bang/product/packages/kyverno-policies/-/blob/main/CHANGELOG.md)
- [and our upstream application release notes here](https://repo1.dso.mil/big-bang/product/packages/kyverno-policies/-/releases)

## Learn More

- [Application Overview](docs/overview.md)
- [Other Documentation](docs/)

## Pre-Requisites

- Kubernetes Cluster deployed
- Kubernetes config installed in `~/.kube/config`
- Helm installed

Install Helm

<https://helm.sh/docs/intro/install/>

## Deployment

- Clone down the repository
- cd into directory

```bash
helm install kyverno-policies chart/
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| kyverno.install | bool | `true` |  |
| waitforready.enabled.".Values.kyverno.install" | string | `nil` |  |
| waitforready.image.repository | string | `"registry1.dso.mil/ironbank/opensource/kubernetes/kubectl"` |  |
| waitforready.image.tag | string | `"v1.30.5"` |  |
| waitforready.imagePullSecrets[0].name | string | `"private-registry"` |  |
| templating.enabled | bool | `false` |  |
| templating.debug | bool | `false` |  |
| templating.version | string | `nil` |  |
| enabled | bool | `true` | Enable policy deployments |
| validationFailureAction | string | `""` | Override all policies' validation failure action with "Audit" or "Enforce".  If blank, uses policy setting. |
| failurePolicy | string | `"Fail"` | API server behavior if the webhook fails to respond ('Ignore', 'Fail') For more info: <https://kyverno.io/docs/writing-policies/policy-settings/> |
| background | bool | `true` | Policies background mode |
| kyvernoVersion | string | `"autodetect"` | Kyverno version The default of "autodetect" will try to determine the currently installed version from the deployment |
| webhookTimeoutSeconds | int | `30` | Override all policies' time to wait for admission webhook to respond.  If blank, uses policy setting or default (10).  Range is 1 to 30. |
| exclude | object | `{"any":[{"resources":{"namespaces":["kube-system"]}}]}` | Adds an exclusion to all policies.  This is merged with any policy-specific excludes.  See <https://kyverno.io/docs/writing-policies/match-exclude> for fields. |
| excludeContainers | list | `[]` | Adds an excludeContainers to all policies.  This is merged with any policy-specific excludeContainers. |
| autogenControllers | string | `"Deployment,ReplicaSet,DaemonSet,StatefulSet"` | Customize the target Pod controllers for the auto-generated rules. (Eg. `none`, `Deployment`, `DaemonSet,Deployment,StatefulSet`) For more info <https://kyverno.io/docs/writing-policies/autogen/>. |
| customLabels | object | `{}` | Additional labels to apply to all policies. |
| policyPreconditions | object | `{}` | Add preconditions to individual policies. Policies with multiple rules can have individual rules excluded by using the name of the rule as the key in the `policyPreconditions` map. |
| policies.sample | object | `{"enabled":false,"exclude":{},"match":{},"parameters":{"excludeContainers":[]},"validationFailureAction":"Audit","webhookTimeoutSeconds":""}` | Sample policy showing values that can be added to any policy |
| policies.sample.enabled | bool | `false` | Controls policy deployment |
| policies.sample.validationFailureAction | string | `"Audit"` | Controls if a validation policy rule failure should disallow (Enforce) or allow (Audit) the admission |
| policies.sample.webhookTimeoutSeconds | string | `""` | Specifies the maximum time in seconds allowed to apply this policy. Default is 10. Range is 1 to 30. |
| policies.sample.match | object | `{}` | Defines when this policy's rules should be applied.  This completely overrides any default matches. |
| policies.sample.exclude | object | `{}` | Defines when this policy's rules should not be applied.  This completely overrides any default excludes. |
| policies.sample.parameters | object | `{"excludeContainers":[]}` | Policy specific parameters that are added to the configMap for the policy rules |
| policies.sample.parameters.excludeContainers | list | `[]` | Adds a container exclusion (by name) to a specific policy.  This is merged with any global excludeContainers. |
| policies.clone-configs | object | `{"enabled":false,"generateExisting":false,"parameters":{"clone":[]}}` | Clone existing configMap or secret in new Namespaces |
| policies.clone-configs.parameters.clone | list | `[]` | ConfigMap or Secrets that should be cloned.  Each item requres the kind, name, and namespace of the resource to clone |
| policies.disallow-annotations | object | `{"enabled":false,"parameters":{"disallow":[]},"validationFailureAction":"Audit"}` | Prevent specified annotations on pods |
| policies.disallow-annotations.parameters.disallow | list | `[]` | List of annotations disallowed on pods.  Entries can be just a "key", or a quoted "key: value".  Wildcards '*' and '?' are supported. |
| policies.disallow-deprecated-apis | object | `{"enabled":false,"validationFailureAction":"Audit"}` | Prevent resources that use deprecated or removed APIs (through Kubernetes 1.26) |
| policies.disallow-host-namespaces | object | `{"enabled":true,"validationFailureAction":"Enforce"}` | Prevent use of the host namespace (PID, IPC, Network) by pods |
| policies.disallow-image-tags | object | `{"enabled":false,"parameters":{"disallow":["latest"]},"validationFailureAction":"Audit"}` | Prevent container images with specified tags.  Also, requires images to have a tag. |
| policies.disallow-istio-injection-bypass | object | `{"enabled":false,"validationFailureAction":"Audit"}` | Prevent the `sidecar.istio.io/inject: false` label on pods. |
| policies.disallow-labels | object | `{"enabled":false,"parameters":{"disallow":[]},"validationFailureAction":"Audit"}` | Prevent specified labels on pods |
| policies.disallow-labels.parameters.disallow | list | `[]` | List of labels disallowed on pods.  Entries can be just a "key", or a quoted "key: value".  Wildcards '*' and '?' are supported. |
| policies.disallow-namespaces | object | `{"enabled":false,"parameters":{"disallow":["default"]},"validationFailureAction":"Audit"}` | Prevent pods from using the listed namespaces |
| policies.disallow-namespaces.parameters.disallow | list | `["default"]` | List of namespaces to deny pod deployment |
| policies.disallow-nodeport-services | object | `{"enabled":true,"validationFailureAction":"Audit"}` | Prevent services of the type NodePort |
| policies.disallow-pod-exec | object | `{"enabled":false,"validationFailureAction":"Audit"}` | Prevent the use of `exec` or `attach` on pods |
| policies.disallow-privilege-escalation | object | `{"enabled":true,"validationFailureAction":"Enforce"}` | Prevent privilege escalation on pods |
| policies.disallow-auto-mount-service-account-token | object | `{"enabled":true,"validationFailureAction":"Audit"}` | Prevent Automounting of Kubernetes API Credentials on Pods and Service Accounts |
| policies.disallow-privileged-containers | object | `{"enabled":true,"validationFailureAction":"Enforce"}` | Prevent containers that run as privileged |
| policies.disallow-selinux-options | object | `{"enabled":true,"parameters":{"disallow":["user","role"]},"validationFailureAction":"Enforce"}` | Prevent specified SELinux options from being used on pods. |
| policies.disallow-selinux-options.parameters.disallow | list | `["user","role"]` | List of selinux options that are not allowed.  Valid values include `level`, `role`, `type`, and `user`. Defaults pulled from <https://kubernetes.io/docs/concepts/security/pod-security-standards> |
| policies.disallow-tolerations | object | `{"enabled":false,"parameters":{"disallow":[{"key":"node-role.kubernetes.io/master"}]},"validationFailureAction":"Audit"}` | Prevent tolerations that bypass specified taints |
| policies.disallow-tolerations.parameters.disallow | list | `[{"key":"node-role.kubernetes.io/master"}]` | List of taints to protect from toleration.  Each entry can have `key`, `value`, and/or `effect`.  Wildcards '*' and '?' can be used If key, value, or effect are not defined, they are ignored in the policy rule |
| policies.disallow-rbac-on-default-serviceaccounts | object | `{"enabled":false,"exclude":{"any":[{"resources":{"name":"system:service-account-issuer-discovery"}}]},"validationFailureAction":"Audit"}` | Prevent additional RBAC permissions on default service accounts |
| policies.require-annotations | object | `{"enabled":false,"parameters":{"require":[]},"validationFailureAction":"Audit"}` | Require specified annotations on all pods |
| policies.require-annotations.parameters.require | list | `[]` | List of annotations required on all pods.  Entries can be just a "key", or a quoted "key: value".  Wildcards '*' and '?' are supported. |
| policies.require-cpu-limit | object | `{"enabled":false,"parameters":{"require":["<10"]},"validationFailureAction":"Audit"}` | Require containers have CPU limits defined and within the specified range |
| policies.require-cpu-limit.parameters.require | list | `["<10"]` | CPU limitations (only one required condition needs to be met).  The following operators are valid: >, <, >=, <=, !, \|, &. |
| policies.require-drop-all-capabilities | object | `{"enabled":true,"validationFailureAction":"Enforce"}` | Requires containers to drop all Linux capabilities |
| policies.require-image-signature | object | `{"enabled":true,"parameters":{"require":[{"attestors":[{"count":1,"entries":[{"keys":{"ctlog":{"ignoreSCT":true},"publicKeys":"-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtQDv69q1kyiogpxvIVjh\neNMLsI1GTLm+BuLWJN2rq4AA4k3+I7WqdvA1tKJ218DyXExljI3NTD4J5BnLeB6y\nWDvnTPXVu+pNj9W7Az0uyD73/WsMV1QR5VEzWMdMz+ZnN8IGd4JFl9p2N21YBD1R\nY93+K4XgrZ/iSRk+mGBAs87UpF1ku/nru0H2+XwJtoV7pLrrai/pLdQeRh5Ogg9J\nz5qHer9EnZne6eBnZedvpf7bqfRt0Fqqk0pTzLQm4oFD3HnxdJUPt9ccoPx0IyF0\nrB01a53LBTeRXeUcHd5BpwhwgkIm2insbDIp+lBKjUfq4CfqRQcXLLUgtRUij6ke\nQfD7jgI9chBxbVE1U5Mc/RgftXuVGQzx1OrjenD4wIH4whtP1abTg6XLxqjgkgqq\nEJy5kUpv+ut0n1RBiIdH6wYXDum90fq4qQl+gHaER0bOYAQTCIFRrhrWJ8Qxj4uL\nxI+O5KgLX3TanMtfE7e2A86uzxiHBxEW4+AF2IMXuLviIQKc9z+/p93psfQ9nXXj\nB5i6qFWkF0BMuWibB8e+HHWRKLfNWXGdfLraoMPKwCrJWhYQ+8SRrqR+gbSNWbEM\nVardcwrQZ7NP7KIedquYQnfJ3ukbYikKgdBovGStFEPLaKKiYJiD5UIQhZ51SDdA\nk+PgLW7CzKW4u2+WLdjfalkCAwEAAQ==\n-----END PUBLIC KEY-----","rekor":{"ignoreTlog":true,"url":""}}}]}],"imageReferences":["registry1.dso.mil/ironbank/*"],"mutateDigest":false,"verifyDigest":false}]},"validationFailureAction":"Enforce"}` | Require specified images to be signed and verified |
| policies.require-image-signature.parameters.require | list | `[{"attestors":[{"count":1,"entries":[{"keys":{"ctlog":{"ignoreSCT":true},"publicKeys":"-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtQDv69q1kyiogpxvIVjh\neNMLsI1GTLm+BuLWJN2rq4AA4k3+I7WqdvA1tKJ218DyXExljI3NTD4J5BnLeB6y\nWDvnTPXVu+pNj9W7Az0uyD73/WsMV1QR5VEzWMdMz+ZnN8IGd4JFl9p2N21YBD1R\nY93+K4XgrZ/iSRk+mGBAs87UpF1ku/nru0H2+XwJtoV7pLrrai/pLdQeRh5Ogg9J\nz5qHer9EnZne6eBnZedvpf7bqfRt0Fqqk0pTzLQm4oFD3HnxdJUPt9ccoPx0IyF0\nrB01a53LBTeRXeUcHd5BpwhwgkIm2insbDIp+lBKjUfq4CfqRQcXLLUgtRUij6ke\nQfD7jgI9chBxbVE1U5Mc/RgftXuVGQzx1OrjenD4wIH4whtP1abTg6XLxqjgkgqq\nEJy5kUpv+ut0n1RBiIdH6wYXDum90fq4qQl+gHaER0bOYAQTCIFRrhrWJ8Qxj4uL\nxI+O5KgLX3TanMtfE7e2A86uzxiHBxEW4+AF2IMXuLviIQKc9z+/p93psfQ9nXXj\nB5i6qFWkF0BMuWibB8e+HHWRKLfNWXGdfLraoMPKwCrJWhYQ+8SRrqR+gbSNWbEM\nVardcwrQZ7NP7KIedquYQnfJ3ukbYikKgdBovGStFEPLaKKiYJiD5UIQhZ51SDdA\nk+PgLW7CzKW4u2+WLdjfalkCAwEAAQ==\n-----END PUBLIC KEY-----","rekor":{"ignoreTlog":true,"url":""}}}]}],"imageReferences":["registry1.dso.mil/ironbank/*"],"mutateDigest":false,"verifyDigest":false}]` | List of images that must be signed and the public key to verify.  Use `kubectl explain clusterpolicy.spec.rules.verifyImages` for fields. |
| policies.require-istio-on-namespaces | object | `{"enabled":false,"validationFailureAction":"Audit"}` | Require Istio sidecar injection label on namespaces |
| policies.require-labels | object | `{"enabled":true,"parameters":{"require":["app.kubernetes.io/name","app.kubernetes.io/instance","app.kubernetes.io/version","app","version"]},"validationFailureAction":"Audit"}` | Require specified labels to be on all pods |
| policies.require-labels.parameters.require | list | `["app.kubernetes.io/name","app.kubernetes.io/instance","app.kubernetes.io/version","app","version"]` | List of labels required on all pods.  Entries can be just a "key", or a quoted "key: value".  Wildcards '*' and '?' are supported. See <https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels> See <https://helm.sh/docs/chart_best_practices/labels/#standard-labels> |
| policies.require-memory-limit | object | `{"enabled":false,"parameters":{"require":["<64Gi"]},"validationFailureAction":"Audit"}` | Require containers have memory limits defined and within the specified range |
| policies.require-memory-limit.parameters.require | list | `["<64Gi"]` | Memory limitations (only one required condition needs to be met).  Can use standard Kubernetes resource units (e.g. Mi, Gi).  The following operators are valid: >, <, >=, <=, !, \|, &. |
| policies.require-non-root-group | object | `{"enabled":true,"validationFailureAction":"Enforce"}` | Require containers to run with non-root group |
| policies.require-non-root-user | object | `{"enabled":true,"validationFailureAction":"Enforce"}` | Require containers to run as non-root user |
| policies.require-probes | object | `{"enabled":false,"parameters":{"require":["readinessProbe","livenessProbe"]},"validationFailureAction":"Audit"}` | Require specified probes on pods |
| policies.require-probes.parameters.require | list | `["readinessProbe","livenessProbe"]` | List of probes that are required on pods.  Valid values are `readinessProbe`, `livenessProbe`, and `startupProbe`. |
| policies.require-requests-equal-limits | object | `{"enabled":false,"validationFailureAction":"Audit"}` | Require CPU and memory requests equal limits for guaranteed quality of service |
| policies.require-ro-rootfs | object | `{"enabled":false,"validationFailureAction":"Audit"}` | Require containers set root filesystem to read-only |
| policies.restrict-apparmor | object | `{"enabled":true,"parameters":{"allow":["runtime/default","localhost/*"]},"validationFailureAction":"Enforce"}` | Restricts pods that use AppArmor to specified profiles |
| policies.restrict-apparmor.parameters.allow | list | `["runtime/default","localhost/*"]` | List of allowed AppArmor profiles Defaults pulled from <https://kubernetes.io/docs/concepts/security/pod-security-standards/#baseline> |
| policies.restrict-external-ips | object | `{"enabled":true,"parameters":{"allow":[]},"validationFailureAction":"Enforce"}` | Restrict services with External IPs to a specified list (CVE-2020-8554) |
| policies.restrict-external-ips.parameters.allow | list | `[]` | List of external IPs allowed in services.  Must be an IP address.  Use the wildcard `?*` to support subnets (e.g. `192.168.0.?*`) |
| policies.restrict-external-names | object | `{"enabled":true,"parameters":{"allow":[]},"validationFailureAction":"Enforce"}` | Restrict services with External Names to a specified list (CVE-2020-8554) |
| policies.restrict-external-names.parameters.allow | list | `[]` | List of external names allowed in services.  Must be a lowercase RFC-1123 hostname. |
| policies.restrict-capabilities | object | `{"enabled":true,"parameters":{"allow":["NET_BIND_SERVICE"]},"validationFailureAction":"Enforce"}` | Restrict Linux capabilities added to containers to the specified list |
| policies.restrict-capabilities.parameters.allow | list | `["NET_BIND_SERVICE"]` | List of capabilities that are allowed to be added Defaults pulled from <https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted> See <https://man7.org/linux/man-pages/man7/capabilities.7.html> for list of capabilities.  The `CAP_` prefix is removed in Kubernetes names. |
| policies.restrict-group-id | object | `{"enabled":false,"parameters":{"allow":[">=1000"]},"validationFailureAction":"Audit"}` | Restrict container group IDs to specified ranges NOTE: Using require-non-root-group will force runAsGroup to be defined |
| policies.restrict-group-id.parameters.allow | list | `[">=1000"]` | Allowed group IDs / ranges.  The following operators are valid: >, <, >=, <=, !, \|, &. For a lower and upper limit, use ">=min & <=max" |
| policies.restrict-host-path-mount | object | `{"enabled":true,"parameters":{"allow":[]},"validationFailureAction":"Audit"}` | Restrict the paths that can be mounted by hostPath volumes to the allowed list.  HostPath volumes are normally disallowed.  If exceptions are made, the path(s) should be restricted. |
| policies.restrict-host-path-mount.parameters.allow | list | `[]` | List of allowed paths for hostPath volumes to mount |
| policies.restrict-host-path-mount-pv.enabled | bool | `true` |  |
| policies.restrict-host-path-mount-pv.validationFailureAction | string | `"Audit"` |  |
| policies.restrict-host-path-mount-pv.parameters.allow | list | `[]` | List of allowed paths for hostPath volumes to mount |
| policies.restrict-host-path-write | object | `{"enabled":true,"parameters":{"allow":[]},"validationFailureAction":"Audit"}` | Restrict the paths that can be mounted as read/write by hostPath volumes to the allowed list.  HostPath volumes, if allowed, should normally be mounted as read-only.  If exceptions are made, the path(s) should be restricted. |
| policies.restrict-host-path-write.parameters.allow | list | `[]` | List of allowed paths for hostPath volumes to mount as read/write |
| policies.restrict-host-ports | object | `{"enabled":true,"parameters":{"allow":[]},"validationFailureAction":"Enforce"}` | Restrict host ports in containers to the specified list |
| policies.restrict-host-ports.parameters.allow | list | `[]` | List of allowed host ports |
| policies.restrict-image-registries | object | `{"enabled":true,"parameters":{"allow":["registry1.dso.mil"]},"validationFailureAction":"Audit"}` | Restricts container images to registries in the specified list |
| policies.restrict-image-registries.parameters.allow | list | `["registry1.dso.mil"]` | List of allowed registries that images may use |
| policies.restrict-proc-mount | object | `{"enabled":true,"parameters":{"allow":["Default"]},"validationFailureAction":"Enforce"}` | Restrict mounting /proc to the specified mask |
| policies.restrict-proc-mount.parameters.allow | list | `["Default"]` | List of allowed proc mount values.  Valid values are `Default` and `Unmasked`. Defaults pulled from <https://kubernetes.io/docs/concepts/security/pod-security-standards> |
| policies.restrict-seccomp | object | `{"enabled":true,"parameters":{"allow":["RuntimeDefault","Localhost"]},"validationFailureAction":"Enforce"}` | Restrict seccomp profiles to the specified list |
| policies.restrict-seccomp.parameters.allow | list | `["RuntimeDefault","Localhost"]` | List of allowed seccomp profiles.  Valid values are `Localhost`, `RuntimeDefault`, and `Unconfined` Defaults pulled from <https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted> |
| policies.restrict-selinux-type | object | `{"enabled":true,"parameters":{"allow":["container_t","container_init_t","container_kvm_t"]},"validationFailureAction":"Enforce"}` | Restrict SELinux types to the specified list. |
| policies.restrict-selinux-type.parameters.allow | list | `["container_t","container_init_t","container_kvm_t"]` | List of allowed values for the `type` field Defaults pulled from <https://kubernetes.io/docs/concepts/security/pod-security-standards> |
| policies.restrict-sysctls | object | `{"enabled":true,"parameters":{"allow":["kernel.shm_rmid_forced","net.ipv4.ip_local_port_range","net.ipv4.ip_unprivileged_port_start","net.ipv4.tcp_syncookies","net.ipv4.ping_group_range","net.ipv4.ip_local_reserved_ports","net.ipv4.tcp_keepalive_time","net.ipv4.tcp_fin_timeout","net.ipv4.tcp_keepalive_intvl","net.ipv4.tcp_keepalive_probes"]},"validationFailureAction":"Enforce"}` | Restrict sysctls to the specified list |
| policies.restrict-sysctls.parameters.allow | list | `["kernel.shm_rmid_forced","net.ipv4.ip_local_port_range","net.ipv4.ip_unprivileged_port_start","net.ipv4.tcp_syncookies","net.ipv4.ping_group_range","net.ipv4.ip_local_reserved_ports","net.ipv4.tcp_keepalive_time","net.ipv4.tcp_fin_timeout","net.ipv4.tcp_keepalive_intvl","net.ipv4.tcp_keepalive_probes"]` | List of allowed sysctls. Defaults pulled from <https://kubernetes.io/docs/concepts/security/pod-security-standards> |
| policies.restrict-user-id | object | `{"enabled":false,"parameters":{"allow":[">=1000"]},"validationFailureAction":"Audit"}` | Restrict user IDs to the specified ranges NOTE: Using require-non-root-user will force runAsUser to be defined |
| policies.restrict-user-id.parameters.allow | list | `[">=1000"]` | Allowed user IDs / ranges.  The following operators are valid: >, <, >=, <=, !, \|, &. For a lower and upper limit, use ">=min & <=max" |
| policies.restrict-volume-types | object | `{"enabled":true,"parameters":{"allow":["configMap","csi","downwardAPI","emptyDir","ephemeral","persistentVolumeClaim","projected","secret"]},"validationFailureAction":"Enforce"}` | Restrict the volume types to the specified list |
| policies.restrict-volume-types.parameters.allow | list | `["configMap","csi","downwardAPI","emptyDir","ephemeral","persistentVolumeClaim","projected","secret"]` | List of allowed Volume types.  Valid values are the volume types listed here: <https://kubernetes.io/docs/concepts/storage/volumes/#volume-types> Defaults pulled from <https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted> |
| policies.update-image-pull-policy | object | `{"enabled":false,"parameters":{"update":[{"to":"Always"}]}}` | Updates the image pull policy on containers |
| policies.update-image-pull-policy.parameters.update | list | `[{"to":"Always"}]` | List of image pull policy updates.  `from` contains the pull policy value to replace.  If `from` is blank, it matches everything.  `to` contains the new pull policy to use.  Must be one of `Always`, `Never`, or `IfNotPresent`. |
| policies.update-image-registry | object | `{"enabled":false,"parameters":{"update":[]}}` | Updates an existing image registry with a new registry in containers (e.g. proxy) |
| policies.update-image-registry.parameters.update | list | `[]` | List of registry updates.  `from` contains the registry to replace. `to` contains the new registry to use. |
| policies.update-automountserviceaccounttokens-default | object | `{"enabled":false}` | List of namespaces to explictly disable mounting the serviceaccount token |
| policies.update-automountserviceaccounttokens | object | `{"enabled":false}` | List pods to explictly enable mounting the serviceaccount token |
| additionalPolicies | object | `{"samplePolicy":{"annotations":{"policies.kyverno.io/category":"Examples","policies.kyverno.io/description":"This sample policy blocks pods from deploying into the 'default' namespace.","policies.kyverno.io/severity":"low","policies.kyverno.io/subject":"Pod","policies.kyverno.io/title":"Sample Policy"},"enabled":false,"kind":"ClusterPolicy","namespace":"","spec":{"rules":[{"match":{"any":[{"resources":{"kinds":["Pods"]}}]},"name":"sample-rule","validate":{"message":"Using 'default' namespace is not allowed.","pattern":{"metadata":{"namespace":"!default"}}}}]}}}` | Adds custom policies.  See <https://kyverno.io/docs/writing-policies/>. |
| additionalPolicies.samplePolicy | object | `{"annotations":{"policies.kyverno.io/category":"Examples","policies.kyverno.io/description":"This sample policy blocks pods from deploying into the 'default' namespace.","policies.kyverno.io/severity":"low","policies.kyverno.io/subject":"Pod","policies.kyverno.io/title":"Sample Policy"},"enabled":false,"kind":"ClusterPolicy","namespace":"","spec":{"rules":[{"match":{"any":[{"resources":{"kinds":["Pods"]}}]},"name":"sample-rule","validate":{"message":"Using 'default' namespace is not allowed.","pattern":{"metadata":{"namespace":"!default"}}}}]}}` | Name of the policy.  Addtional policies can be added by adding a key. |
| additionalPolicies.samplePolicy.enabled | bool | `false` | Controls policy deployment |
| additionalPolicies.samplePolicy.kind | string | `"ClusterPolicy"` | Kind of policy.  Currently, "ClusterPolicy" and "Policy" are supported. |
| additionalPolicies.samplePolicy.namespace | string | `""` | If kind is "Policy", which namespace to target.  The namespace must already exist. |
| additionalPolicies.samplePolicy.annotations | object | `{"policies.kyverno.io/category":"Examples","policies.kyverno.io/description":"This sample policy blocks pods from deploying into the 'default' namespace.","policies.kyverno.io/severity":"low","policies.kyverno.io/subject":"Pod","policies.kyverno.io/title":"Sample Policy"}` | Policy annotations to add |
| additionalPolicies.samplePolicy.annotations."policies.kyverno.io/title" | string | `"Sample Policy"` | Human readable name of policy |
| additionalPolicies.samplePolicy.annotations."policies.kyverno.io/category" | string | `"Examples"` | Category of policy.  Arbitrary. |
| additionalPolicies.samplePolicy.annotations."policies.kyverno.io/severity" | string | `"low"` | Severity of policy if a violation occurs.  Choose "critical", "high", "medium", "low". |
| additionalPolicies.samplePolicy.annotations."policies.kyverno.io/subject" | string | `"Pod"` | Type of resource policy applies to (e.g. Pod, Service, Namespace) |
| additionalPolicies.samplePolicy.annotations."policies.kyverno.io/description" | string | `"This sample policy blocks pods from deploying into the 'default' namespace."` | Description of what the policy does, why it is important, and what items are allowed or unallowed. |
| additionalPolicies.samplePolicy.spec | object | `{"rules":[{"match":{"any":[{"resources":{"kinds":["Pods"]}}]},"name":"sample-rule","validate":{"message":"Using 'default' namespace is not allowed.","pattern":{"metadata":{"namespace":"!default"}}}}]}` | Policy specification.  See `kubectl explain clusterpolicies.spec` |
| additionalPolicies.samplePolicy.spec.rules | list | `[{"match":{"any":[{"resources":{"kinds":["Pods"]}}]},"name":"sample-rule","validate":{"message":"Using 'default' namespace is not allowed.","pattern":{"metadata":{"namespace":"!default"}}}}]` | Policy rules.  At least one is required |
| waitJob.enabled | bool | `true` |  |
| waitJob.kind | string | `"ClusterRole"` |  |
| waitJob.scripts.image | string | `"registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.30.5"` |  |
| waitJob.permissions.apiGroups[0] | string | `"kyverno.io"` |  |
| waitJob.permissions.resources[0] | string | `"clusterpolicies"` |  |
| waitJob.permissions.resources[1] | string | `"policies"` |  |
| networkPolicies.enabled | bool | `false` |  |
| networkPolicies.controlPlaneCidr | string | `"0.0.0.0/0"` |  |
| networkPolicies.externalRegistries.allowEgress | bool | `false` |  |
| networkPolicies.externalRegistries.ports | list | `[]` |  |
| networkPolicies.allowExternalRegistryEgress | bool | `false` |  |
| networkPolicies.additionalPolicies | list | `[]` |  |
| istio.enabled | bool | `false` |  |
| openshift | bool | `false` |  |
| nameOverride | string | `nil` | Override the name of the chart |
| fullnameOverride | string | `nil` | Override the expanded name of the chart |
| namespaceOverride | string | `nil` | Override the namespace the chart deploys to |
| crds.install | bool | `true` | Whether to have Helm install the Kyverno CRDs, if the CRDs are not installed by Helm, they must be added before policies can be created |
| crds.groups.kyverno | object | `{"admissionreports":true,"backgroundscanreports":true,"cleanuppolicies":true,"clusteradmissionreports":true,"clusterbackgroundscanreports":true,"clustercleanuppolicies":true,"clusterpolicies":true,"globalcontextentries":true,"policies":true,"policyexceptions":true,"updaterequests":true}` | Install CRDs in group `kyverno.io` |
| crds.groups.reports | object | `{"clusterephemeralreports":true,"ephemeralreports":true}` | Install CRDs in group `reports.kyverno.io` |
| crds.groups.wgpolicyk8s | object | `{"clusterpolicyreports":true,"policyreports":true}` | Install CRDs in group `wgpolicyk8s.io` |
| crds.annotations | object | `{}` | Additional CRDs annotations |
| crds.customLabels | object | `{}` | Additional CRDs labels |
| crds.migration.enabled | bool | `true` | Enable CRDs migration using helm post upgrade hook |
| crds.migration.resources | list | `["admissionreports.kyverno.io","backgroundscanreports.kyverno.io","cleanuppolicies.kyverno.io","clusteradmissionreports.kyverno.io","clusterbackgroundscanreports.kyverno.io","clustercleanuppolicies.kyverno.io","clusterpolicies.kyverno.io","globalcontextentries.kyverno.io","policies.kyverno.io","policyexceptions.kyverno.io","updaterequests.kyverno.io"]` | Resources to migrate |
| crds.migration.image.registry | string | `"registry1.dso.mil"` | Image registry |
| crds.migration.image.repository | string | `"ironbank/opensource/kyverno/kyvernocli"` | Image repository |
| crds.migration.image.tag | string | `"v1.12.6"` | Image tag Defaults to appVersion in Chart.yaml if omitted |
| crds.migration.image.pullPolicy | string | `nil` | Image pull policy |
| crds.migration.imagePullSecrets[0].name | string | `"private-registry"` |  |
| crds.podSecurityContext | object | `{"nodeAffinity":{},"nodeSelector":{},"podAffinity":{},"podAnnotations":{},"podAntiAffinity":{},"podLabels":{},"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}},"tolerations":[]}` | Security context for the pod |
| crds.podSecurityContext.nodeSelector | object | `{}` | Node labels for pod assignment |
| crds.podSecurityContext.tolerations | list | `[]` | List of node taints to tolerate |
| crds.podSecurityContext.podAntiAffinity | object | `{}` | Pod anti affinity constraints. |
| crds.podSecurityContext.podAffinity | object | `{}` | Pod affinity constraints. |
| crds.podSecurityContext.podLabels | object | `{}` | Pod labels. |
| crds.podSecurityContext.podAnnotations | object | `{}` | Pod annotations. |
| crds.podSecurityContext.nodeAffinity | object | `{}` | Node affinity constraints. |
| crds.podSecurityContext.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the hook containers |
| config.create | bool | `true` | Create the configmap. |
| config.preserve | bool | `true` | Preserve the configmap settings during upgrade. |
| config.name | string | `nil` | The configmap name (required if `create` is `false`). |
| config.annotations | object | `{}` | Additional annotations to add to the configmap. |
| config.enableDefaultRegistryMutation | bool | `true` | Enable registry mutation for container images. Enabled by default. |
| config.defaultRegistry | string | `"registry1.dso.mil"` | The registry hostname used for the image mutation. |
| config.excludeGroups | list | `["system:nodes"]` | Exclude groups |
| config.excludeUsernames | list | `[]` | Exclude usernames |
| config.excludeRoles | list | `[]` | Exclude roles |
| config.excludeClusterRoles | list | `[]` | Exclude roles |
| config.generateSuccessEvents | bool | `false` | Generate success events. |
| config.resourceFilters | list | See [values.yaml](values.yaml) | Resource types to be skipped by the Kyverno policy engine. Make sure to surround each entry in quotes so that it doesn't get parsed as a nested YAML list. These are joined together without spaces, run through `tpl`, and the result is set in the config map. |
| config.webhooks | list | `[{"namespaceSelector":{"matchExpressions":[{"key":"kubernetes.io/metadata.name","operator":"NotIn","values":["kube-system"]}]}}]` | Defines the `namespaceSelector` in the webhook configurations. Note that it takes a list of `namespaceSelector` and/or `objectSelector` in the JSON format, and only the first element will be forwarded to the webhook configurations. The Kyverno namespace is excluded if `excludeKyvernoNamespace` is `true` (default) |
| config.webhookAnnotations | object | `{"admissions.enforcer/disabled":"true"}` | Defines annotations to set on webhook configurations. |
| config.webhookLabels | object | `{}` | Defines labels to set on webhook configurations. |
| config.matchConditions | list | `[]` | Defines match conditions to set on webhook configurations (requires Kubernetes 1.27+). |
| config.excludeKyvernoNamespace | bool | `true` | Exclude Kyverno namespace Determines if default Kyverno namespace exclusion is enabled for webhooks and resourceFilters |
| config.resourceFiltersExcludeNamespaces | list | `[]` | resourceFilter namespace exclude Namespaces to exclude from the default resourceFilters |
| config.resourceFiltersExclude | list | `[]` | resourceFilters exclude list Items to exclude from config.resourceFilters |
| config.resourceFiltersIncludeNamespaces | list | `[]` | resourceFilter namespace include Namespaces to include to the default resourceFilters |
| config.resourceFiltersInclude | list | `[]` | resourceFilters include list Items to include to config.resourceFilters |
| metricsConfig.create | bool | `true` | Create the configmap. |
| metricsConfig.name | string | `nil` | The configmap name (required if `create` is `false`). |
| metricsConfig.annotations | object | `{}` | Additional annotations to add to the configmap. |
| metricsConfig.namespaces.include | list | `[]` | List of namespaces to capture metrics for. |
| metricsConfig.namespaces.exclude | list | `[]` | list of namespaces to NOT capture metrics for. |
| metricsConfig.metricsRefreshInterval | string | `nil` | Rate at which metrics should reset so as to clean up the memory footprint of kyverno metrics, if you might be expecting high memory footprint of Kyverno's metrics. Default: 0, no refresh of metrics. WARNING: This flag is not working since Kyverno 1.8.0 |
| metricsConfig.bucketBoundaries | list | `[0.005,0.01,0.025,0.05,0.1,0.25,0.5,1,2.5,5,10,15,20,25,30]` | Configures the bucket boundaries for all Histogram metrics, changing this configuration requires restart of the kyverno admission controller |
| metricsConfig.metricsExposure | map | `nil` | Configures the exposure of individual metrics, by default all metrics and all labels are exported, changing this configuration requires restart of the kyverno admission controller |
| imagePullSecrets | object | `{}` | Image pull secrets for image verification policies, this will define the `--imagePullSecrets` argument |
| existingImagePullSecrets | list | `["private-registry"]` | Existing Image pull secrets for image verification policies, this will define the `--imagePullSecrets` argument |
| test.image.registry | string | `"registry1.dso.mil"` | Image registry |
| test.image.repository | string | `"ironbank/redhat/ubi/ubi9-minimal"` | Image repository |
| test.image.tag | string | `"9.4"` | Image tag Defaults to `latest` if omitted |
| test.image.pullPolicy | string | `nil` | Image pull policy Defaults to image.pullPolicy if omitted |
| test.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| test.resources.limits | object | `{"cpu":"100m","memory":"256Mi"}` | Pod resource limits |
| test.resources.requests | object | `{"cpu":"10m","memory":"64Mi"}` | Pod resource requests |
| test.podSecurityContext | object | `{"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534}` | Security context for the test pod |
| test.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the test containers |
| webhooksCleanup | object | `{"automountServiceAccountToken":{"enabled":true},"enabled":true,"image":{"pullPolicy":null,"registry":"registry1.dso.mil","repository":"ironbank/opensource/kubernetes/kubectl","tag":"v1.30.5"},"imagePullSecrets":[{"name":"private-registry"}],"nodeAffinity":{},"nodeSelector":{},"podAffinity":{},"podAnnotations":{},"podAntiAffinity":{},"podLabels":{},"podSecurityContext":{"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001},"resources":{"limits":{"cpu":"0.5","memory":"256Mi"},"requests":{"cpu":"0.5","memory":"256Mi"}},"securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001,"seccompProfile":{"type":"RuntimeDefault"}},"tolerations":[]}` | Additional labels |
| webhooksCleanup.enabled | bool | `true` | Create a helm pre-delete hook to cleanup webhooks. |
| webhooksCleanup.image.registry | string | `"registry1.dso.mil"` | Image registry |
| webhooksCleanup.image.repository | string | `"ironbank/opensource/kubernetes/kubectl"` | Image repository |
| webhooksCleanup.image.tag | string | `"v1.30.5"` | Image tag Defaults to `latest` if omitted |
| webhooksCleanup.image.pullPolicy | string | `nil` | Image pull policy Defaults to image.pullPolicy if omitted |
| webhooksCleanup.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| webhooksCleanup.podSecurityContext | object | `{"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001}` | Security context for the pod |
| webhooksCleanup.nodeSelector | object | `{}` | Node labels for pod assignment |
| webhooksCleanup.tolerations | list | `[]` | List of node taints to tolerate |
| webhooksCleanup.podAntiAffinity | object | `{}` | Pod anti affinity constraints. |
| webhooksCleanup.podAffinity | object | `{}` | Pod affinity constraints. |
| webhooksCleanup.podLabels | object | `{}` | Pod labels. |
| webhooksCleanup.podAnnotations | object | `{}` | Pod annotations. |
| webhooksCleanup.nodeAffinity | object | `{}` | Node affinity constraints. |
| webhooksCleanup.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the hook containers |
| webhooksCleanup.resources | object | `{"limits":{"cpu":"0.5","memory":"256Mi"},"requests":{"cpu":"0.5","memory":"256Mi"}}` | Resource limits for the containers |
| policyReportsCleanup.enabled | bool | `false` | Create a helm post-upgrade hook to cleanup the old policy reports. |
| policyReportsCleanup.automountServiceAccountToken.enabled | bool | `true` |  |
| policyReportsCleanup.image.registry | string | `"registry1.dso.mil"` | Image registry |
| policyReportsCleanup.image.repository | string | `"ironbank/opensource/kubernetes/kubectl"` | Image repository |
| policyReportsCleanup.image.tag | string | `"v1.30.5"` | Image tag Defaults to `latest` if omitted |
| policyReportsCleanup.image.pullPolicy | string | `nil` | Image pull policy Defaults to image.pullPolicy if omitted |
| policyReportsCleanup.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| policyReportsCleanup.podSecurityContext | object | `{"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001}` | Security context for the pod |
| policyReportsCleanup.nodeSelector | object | `{}` | Node labels for pod assignment |
| policyReportsCleanup.tolerations | list | `[]` | List of node taints to tolerate |
| policyReportsCleanup.podAntiAffinity | object | `{}` | Pod anti affinity constraints. |
| policyReportsCleanup.podAffinity | object | `{}` | Pod affinity constraints. |
| policyReportsCleanup.podLabels | object | `{}` | Pod labels. |
| policyReportsCleanup.podAnnotations | object | `{}` | Pod annotations. |
| policyReportsCleanup.nodeAffinity | object | `{}` | Node affinity constraints. |
| policyReportsCleanup.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the hook containers |
| policyReportsCleanup.resources | object | `{"limits":{"cpu":"1","memory":"512Mi"},"requests":{"cpu":"0.5","memory":"256Mi"}}` | Resource limits for the containers |
| grafana.enabled | bool | `false` | Enable grafana dashboard creation. |
| grafana.configMapName | string | `"{{ include \"kyverno.fullname\" . }}-grafana"` | Configmap name template. |
| grafana.namespace | string | `nil` | Namespace to create the grafana dashboard configmap. If not set, it will be created in the same namespace where the chart is deployed. |
| grafana.annotations | object | `{}` | Grafana dashboard configmap annotations. |
| grafana.labels | object | `{"grafana_dashboard":"1"}` | Grafana dashboard configmap labels |
| grafana.grafanaDashboard | object | `{"create":false,"matchLabels":{"dashboards":"grafana"}}` | create GrafanaDashboard custom resource referencing to the configMap. according to <https://grafana-operator.github.io/grafana-operator/docs/examples/dashboard_from_configmap/readme/> |
| features.admissionReports.enabled | bool | `true` | Enables the feature |
| features.aggregateReports.enabled | bool | `true` | Enables the feature |
| features.policyReports.enabled | bool | `true` | Enables the feature |
| features.validatingAdmissionPolicyReports.enabled | bool | `false` | Enables the feature |
| features.autoUpdateWebhooks.enabled | bool | `true` | Enables the feature |
| features.backgroundScan.enabled | bool | `true` | Enables the feature |
| features.backgroundScan.backgroundScanWorkers | int | `2` | Number of background scan workers |
| features.backgroundScan.backgroundScanInterval | string | `"1h"` | Background scan interval |
| features.backgroundScan.skipResourceFilters | bool | `true` | Skips resource filters in background scan |
| features.configMapCaching.enabled | bool | `true` | Enables the feature |
| features.deferredLoading.enabled | bool | `true` | Enables the feature |
| features.dumpPayload.enabled | bool | `false` | Enables the feature |
| features.forceFailurePolicyIgnore.enabled | bool | `false` | Enables the feature |
| features.generateValidatingAdmissionPolicy.enabled | bool | `false` | Enables the feature |
| features.globalContext.maxApiCallResponseLength | int | `2000000` | Maximum allowed response size from API Calls. A value of 0 bypasses checks (not recommended) |
| features.logging.format | string | `"text"` | Logging format |
| features.logging.verbosity | int | `2` | Logging verbosity |
| features.omitEvents.eventTypes | list | `["PolicyApplied","PolicySkipped"]` | Events which should not be emitted (possible values `PolicyViolation`, `PolicyApplied`, `PolicyError`, and `PolicySkipped`) |
| features.policyExceptions.enabled | bool | `true` | Enables the feature |
| features.policyExceptions.namespace | string | `"kyverno"` | Restrict policy exceptions to a single namespace |
| features.protectManagedResources.enabled | bool | `false` | Enables the feature |
| features.registryClient.allowInsecure | bool | `false` | Allow insecure registry |
| features.registryClient.credentialHelpers | list | `["default","google","amazon","azure","github"]` | Enable registry client helpers |
| features.reports.chunkSize | int | `0` | Reports chunk size |
| features.ttlController.reconciliationInterval | string | `"1m"` | Reconciliation interval for the label based cleanup manager |
| features.tuf.enabled | bool | `false` | Enables the feature |
| features.tuf.root | string | `nil` | Tuf root |
| features.tuf.mirror | string | `nil` | Tuf mirror |
| cleanupJobs.rbac.serviceAccount.automountServiceAccountToken.enabled | bool | `false` |  |
| cleanupJobs.admissionReports.enabled | bool | `true` | Enable cleanup cronjob |
| cleanupJobs.admissionReports.automountServiceAccountToken.enabled | bool | `true` |  |
| cleanupJobs.admissionReports.backoffLimit | int | `3` | Maximum number of retries before considering a Job as failed. Defaults to 3. |
| cleanupJobs.admissionReports.image.registry | string | `"registry1.dso.mil"` | Image registry |
| cleanupJobs.admissionReports.image.repository | string | `"ironbank/opensource/kubernetes/kubectl"` | Image repository |
| cleanupJobs.admissionReports.image.tag | string | `"v1.30.5"` | Image tag Defaults to `latest` if omitted |
| cleanupJobs.admissionReports.image.pullPolicy | string | `nil` | Image pull policy Defaults to image.pullPolicy if omitted |
| cleanupJobs.admissionReports.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| cleanupJobs.admissionReports.schedule | string | `"*/10 * * * *"` | Cronjob schedule |
| cleanupJobs.admissionReports.threshold | int | `10000` | Reports threshold, if number of reports are above this value the cronjob will start deleting them |
| cleanupJobs.admissionReports.history | object | `{"failure":1,"success":1}` | Cronjob history |
| cleanupJobs.admissionReports.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context for the pod |
| cleanupJobs.admissionReports.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the containers |
| cleanupJobs.admissionReports.priorityClassName | string | `""` | Pod PriorityClassName |
| cleanupJobs.admissionReports.resources | object | `{}` | Job resources |
| cleanupJobs.admissionReports.tolerations | list | `[]` | List of node taints to tolerate |
| cleanupJobs.admissionReports.nodeSelector | object | `{}` | Node labels for pod assignment |
| cleanupJobs.admissionReports.podAnnotations | object | `{}` | Pod Annotations |
| cleanupJobs.admissionReports.podLabels | object | `{}` | Pod labels |
| cleanupJobs.admissionReports.podAntiAffinity | object | `{}` | Pod anti affinity constraints. |
| cleanupJobs.admissionReports.podAffinity | object | `{}` | Pod affinity constraints. |
| cleanupJobs.admissionReports.nodeAffinity | object | `{}` | Node affinity constraints. |
| cleanupJobs.clusterAdmissionReports.enabled | bool | `true` | Enable cleanup cronjob |
| cleanupJobs.clusterAdmissionReports.automountServiceAccountToken.enabled | bool | `true` |  |
| cleanupJobs.clusterAdmissionReports.backoffLimit | int | `3` | Maximum number of retries before considering a Job as failed. Defaults to 3. |
| cleanupJobs.clusterAdmissionReports.image.registry | string | `"registry1.dso.mil"` | Image registry |
| cleanupJobs.clusterAdmissionReports.image.repository | string | `"ironbank/opensource/kubernetes/kubectl"` | Image repository |
| cleanupJobs.clusterAdmissionReports.image.tag | string | `"v1.30.5"` | Image tag Defaults to `latest` if omitted |
| cleanupJobs.clusterAdmissionReports.image.pullPolicy | string | `nil` | Image pull policy Defaults to image.pullPolicy if omitted |
| cleanupJobs.clusterAdmissionReports.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| cleanupJobs.clusterAdmissionReports.schedule | string | `"*/10 * * * *"` | Cronjob schedule |
| cleanupJobs.clusterAdmissionReports.threshold | int | `10000` | Reports threshold, if number of reports are above this value the cronjob will start deleting them |
| cleanupJobs.clusterAdmissionReports.history | object | `{"failure":1,"success":1}` | Cronjob history |
| cleanupJobs.clusterAdmissionReports.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context for the pod |
| cleanupJobs.clusterAdmissionReports.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the containers |
| cleanupJobs.clusterAdmissionReports.priorityClassName | string | `""` | Pod PriorityClassName |
| cleanupJobs.clusterAdmissionReports.resources | object | `{}` | Job resources |
| cleanupJobs.clusterAdmissionReports.tolerations | list | `[]` | List of node taints to tolerate |
| cleanupJobs.clusterAdmissionReports.nodeSelector | object | `{}` | Node labels for pod assignment |
| cleanupJobs.clusterAdmissionReports.podAnnotations | object | `{}` | Pod Annotations |
| cleanupJobs.clusterAdmissionReports.podLabels | object | `{}` | Pod Labels |
| cleanupJobs.clusterAdmissionReports.podAntiAffinity | object | `{}` | Pod anti affinity constraints. |
| cleanupJobs.clusterAdmissionReports.podAffinity | object | `{}` | Pod affinity constraints. |
| cleanupJobs.clusterAdmissionReports.nodeAffinity | object | `{}` | Node affinity constraints. |
| cleanupJobs.updateRequests.enabled | bool | `true` | Enable cleanup cronjob |
| cleanupJobs.updateRequests.automountServiceAccountToken.enabled | bool | `true` |  |
| cleanupJobs.updateRequests.backoffLimit | int | `3` | Maximum number of retries before considering a Job as failed. Defaults to 3. |
| cleanupJobs.updateRequests.ttlSecondsAfterFinished | string | `""` | Time until the pod from the cronjob is deleted |
| cleanupJobs.updateRequests.image.registry | string | `"registry1.dso.mil"` | Image registry |
| cleanupJobs.updateRequests.image.repository | string | `"ironbank/opensource/kubernetes/kubectl"` | Image repository |
| cleanupJobs.updateRequests.image.tag | string | `"v1.30.5"` | Image tag Defaults to `latest` if omitted |
| cleanupJobs.updateRequests.image.pullPolicy | string | `nil` | Image pull policy Defaults to image.pullPolicy if omitted |
| cleanupJobs.updateRequests.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| cleanupJobs.updateRequests.schedule | string | `"*/10 * * * *"` | Cronjob schedule |
| cleanupJobs.updateRequests.threshold | int | `10000` | Reports threshold, if number of updateRequests are above this value the cronjob will start deleting them |
| cleanupJobs.updateRequests.history | object | `{"failure":1,"success":1}` | Cronjob history |
| cleanupJobs.updateRequests.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context for the pod |
| cleanupJobs.updateRequests.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the containers |
| cleanupJobs.updateRequests.priorityClassName | string | `""` | Pod PriorityClassName |
| cleanupJobs.updateRequests.resources | object | `{}` | Job resources |
| cleanupJobs.updateRequests.tolerations | list | `[]` | List of node taints to tolerate |
| cleanupJobs.updateRequests.nodeSelector | object | `{}` | Node labels for pod assignment |
| cleanupJobs.updateRequests.podAnnotations | object | `{}` | Pod Annotations |
| cleanupJobs.updateRequests.podLabels | object | `{}` | Pod labels |
| cleanupJobs.updateRequests.podAntiAffinity | object | `{}` | Pod anti affinity constraints. |
| cleanupJobs.updateRequests.podAffinity | object | `{}` | Pod affinity constraints. |
| cleanupJobs.updateRequests.nodeAffinity | object | `{}` | Node affinity constraints. |
| cleanupJobs.ephemeralReports.enabled | bool | `true` | Enable cleanup cronjob |
| cleanupJobs.ephemeralReports.automountServiceAccountToken.enabled | bool | `true` |  |
| cleanupJobs.ephemeralReports.backoffLimit | int | `3` | Maximum number of retries before considering a Job as failed. Defaults to 3. |
| cleanupJobs.ephemeralReports.ttlSecondsAfterFinished | string | `""` | Time until the pod from the cronjob is deleted |
| cleanupJobs.ephemeralReports.image.registry | string | `"registry1.dso.mil"` | Image registry |
| cleanupJobs.ephemeralReports.image.repository | string | `"ironbank/opensource/kubernetes/kubectl"` | Image repository |
| cleanupJobs.ephemeralReports.image.tag | string | `"v1.30.5"` | Image tag Defaults to `latest` if omitted |
| cleanupJobs.ephemeralReports.image.pullPolicy | string | `nil` | Image pull policy Defaults to image.pullPolicy if omitted |
| cleanupJobs.ephemeralReports.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| cleanupJobs.ephemeralReports.schedule | string | `"*/10 * * * *"` | Cronjob schedule |
| cleanupJobs.ephemeralReports.threshold | int | `10000` | Reports threshold, if number of updateRequests are above this value the cronjob will start deleting them |
| cleanupJobs.ephemeralReports.history | object | `{"failure":1,"success":1}` | Cronjob history |
| cleanupJobs.ephemeralReports.podSecurityContext | object | `{"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001}` | Security context for the pod |
| cleanupJobs.ephemeralReports.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the containers |
| cleanupJobs.ephemeralReports.priorityClassName | string | `""` | Pod PriorityClassName |
| cleanupJobs.ephemeralReports.resources | object | `{}` | Job resources |
| cleanupJobs.ephemeralReports.tolerations | list | `[]` | List of node taints to tolerate |
| cleanupJobs.ephemeralReports.nodeSelector | object | `{}` | Node labels for pod assignment |
| cleanupJobs.ephemeralReports.podAnnotations | object | `{}` | Pod Annotations |
| cleanupJobs.ephemeralReports.podLabels | object | `{}` | Pod labels |
| cleanupJobs.ephemeralReports.podAntiAffinity | object | `{}` | Pod anti affinity constraints. |
| cleanupJobs.ephemeralReports.podAffinity | object | `{}` | Pod affinity constraints. |
| cleanupJobs.ephemeralReports.nodeAffinity | object | `{}` | Node affinity constraints. |
| cleanupJobs.clusterEphemeralReports.enabled | bool | `true` | Enable cleanup cronjob |
| cleanupJobs.clusterEphemeralReports.automountServiceAccountToken.enabled | bool | `true` |  |
| cleanupJobs.clusterEphemeralReports.backoffLimit | int | `3` | Maximum number of retries before considering a Job as failed. Defaults to 3. |
| cleanupJobs.clusterEphemeralReports.ttlSecondsAfterFinished | string | `""` | Time until the pod from the cronjob is deleted |
| cleanupJobs.clusterEphemeralReports.image.registry | string | `"registry1.dso.mil"` | Image registry |
| cleanupJobs.clusterEphemeralReports.image.repository | string | `"ironbank/opensource/kubernetes/kubectl"` | Image repository |
| cleanupJobs.clusterEphemeralReports.image.tag | string | `"v1.30.5"` | Image tag Defaults to `latest` if omitted |
| cleanupJobs.clusterEphemeralReports.image.pullPolicy | string | `nil` | Image pull policy Defaults to image.pullPolicy if omitted |
| cleanupJobs.clusterEphemeralReports.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| cleanupJobs.clusterEphemeralReports.schedule | string | `"*/10 * * * *"` | Cronjob schedule |
| cleanupJobs.clusterEphemeralReports.threshold | int | `10000` | Reports threshold, if number of reports are above this value the cronjob will start deleting them |
| cleanupJobs.clusterEphemeralReports.history | object | `{"failure":1,"success":1}` | Cronjob history |
| cleanupJobs.clusterEphemeralReports.podSecurityContext | object | `{"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001}` | Security context for the pod |
| cleanupJobs.clusterEphemeralReports.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the containers |
| cleanupJobs.clusterEphemeralReports.priorityClassName | string | `""` | Pod PriorityClassName |
| cleanupJobs.clusterEphemeralReports.resources | object | `{}` | Job resources |
| cleanupJobs.clusterEphemeralReports.tolerations | list | `[]` | List of node taints to tolerate |
| cleanupJobs.clusterEphemeralReports.nodeSelector | object | `{}` | Node labels for pod assignment |
| cleanupJobs.clusterEphemeralReports.podAnnotations | object | `{}` | Pod Annotations |
| cleanupJobs.clusterEphemeralReports.podLabels | object | `{}` | Pod Labels |
| cleanupJobs.clusterEphemeralReports.podAntiAffinity | object | `{}` | Pod anti affinity constraints. |
| cleanupJobs.clusterEphemeralReports.podAffinity | object | `{}` | Pod affinity constraints. |
| cleanupJobs.clusterEphemeralReports.nodeAffinity | object | `{}` | Node affinity constraints. |
| admissionController.featuresOverride | object | `{"admissionReports":{"backPressureThreshold":1000}}` | Overrides features defined at the root level |
| admissionController.featuresOverride.admissionReports.backPressureThreshold | int | `1000` | Max number of admission reports allowed in flight until the admission controller stops creating new ones |
| admissionController.rbac.create | bool | `true` | Create RBAC resources |
| admissionController.rbac.serviceAccount.name | string | `nil` | The ServiceAccount name |
| admissionController.rbac.serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount |
| admissionController.rbac.serviceAccount.automountServiceAccountToken.enabled | bool | `false` |  |
| admissionController.rbac.deployment.automountServiceAccountToken.enabled | bool | `true` |  |
| admissionController.rbac.coreClusterRole.extraResources | list | See [values.yaml](values.yaml) | Extra resource permissions to add in the core cluster role. This was introduced to avoid breaking change in the chart but should ideally be moved in `clusterRole.extraResources`. |
| admissionController.rbac.clusterRole.extraResources | list | `[]` | Extra resource permissions to add in the cluster role |
| admissionController.createSelfSignedCert | bool | `false` | Create self-signed certificates at deployment time. The certificates won't be automatically renewed if this is set to `true`. |
| admissionController.replicas | int | `3` | Desired number of pods |
| admissionController.podLabels | object | `{}` | Additional labels to add to each pod |
| admissionController.podAnnotations | object | `{}` | Additional annotations to add to each pod |
| admissionController.updateStrategy | object | See [values.yaml](values.yaml) | Deployment update strategy. Ref: <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy> |
| admissionController.priorityClassName | string | `""` | Optional priority class |
| admissionController.apiPriorityAndFairness | bool | `false` | Change `apiPriorityAndFairness` to `true` if you want to insulate the API calls made by Kyverno admission controller activities. This will help ensure Kyverno stability in busy clusters. Ref: <https://kubernetes.io/docs/concepts/cluster-administration/flow-control/> |
| admissionController.priorityLevelConfigurationSpec | object | See [values.yaml](values.yaml) | Priority level configuration. The block is directly forwarded into the priorityLevelConfiguration, so you can use whatever specification you want. ref: <https://kubernetes.io/docs/concepts/cluster-administration/flow-control/#prioritylevelconfiguration> |
| admissionController.hostNetwork | bool | `false` | Change `hostNetwork` to `true` when you want the pod to share its host's network namespace. Useful for situations like when you end up dealing with a custom CNI over Amazon EKS. Update the `dnsPolicy` accordingly as well to suit the host network mode. |
| admissionController.webhookServer | object | `{"port":9443}` | admissionController webhook server port in case you are using hostNetwork: true, you might want to change the port the webhookServer is listening to |
| admissionController.dnsPolicy | string | `"ClusterFirst"` | `dnsPolicy` determines the manner in which DNS resolution happens in the cluster. In case of `hostNetwork: true`, usually, the `dnsPolicy` is suitable to be `ClusterFirstWithHostNet`. For further reference: <https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy>. |
| admissionController.startupProbe | object | See [values.yaml](values.yaml) | Startup probe. The block is directly forwarded into the deployment, so you can use whatever startupProbes configuration you want. ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/> |
| admissionController.livenessProbe | object | See [values.yaml](values.yaml) | Liveness probe. The block is directly forwarded into the deployment, so you can use whatever livenessProbe configuration you want. ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/> |
| admissionController.readinessProbe | object | See [values.yaml](values.yaml) | Readiness Probe. The block is directly forwarded into the deployment, so you can use whatever readinessProbe configuration you want. ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/> |
| admissionController.nodeSelector | object | `{}` | Node labels for pod assignment |
| admissionController.tolerations | list | `[]` | List of node taints to tolerate |
| admissionController.antiAffinity.enabled | bool | `true` | Pod antiAffinities toggle. Enabled by default but can be disabled if you want to schedule pods to the same node. |
| admissionController.podAntiAffinity | object | See [values.yaml](values.yaml) | Pod anti affinity constraints. |
| admissionController.podAffinity | object | `{}` | Pod affinity constraints. |
| admissionController.nodeAffinity | object | `{}` | Node affinity constraints. |
| admissionController.topologySpreadConstraints | list | `[]` | Topology spread constraints. |
| admissionController.podSecurityContext | object | `{"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}` | Security context for the pod |
| admissionController.podDisruptionBudget.enabled | bool | `false` | Enable PodDisruptionBudget. Will always be enabled if replicas > 1. This non-declarative behavior should ideally be avoided, but changing it now would be breaking. |
| admissionController.podDisruptionBudget.minAvailable | int | `1` | Configures the minimum available pods for disruptions. Cannot be used if `maxUnavailable` is set. |
| admissionController.podDisruptionBudget.maxUnavailable | string | `nil` | Configures the maximum unavailable pods for disruptions. Cannot be used if `minAvailable` is set. |
| admissionController.tufRootMountPath | string | `"/.sigstore"` | A writable volume to use for the TUF root initialization. |
| admissionController.sigstoreVolume | object | `{"emptyDir":{}}` | Volume to be mounted in pods for TUF/cosign work. |
| admissionController.caCertificates.data | string | `nil` | CA certificates to use with Kyverno deployments This value is expected to be one large string of CA certificates |
| admissionController.caCertificates.volume | object | `{}` | Volume to be mounted for CA certificates Not used when `.Values.admissionController.caCertificates.data` is defined |
| admissionController.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| admissionController.initContainer.image.registry | string | `"registry1.dso.mil"` | Image registry |
| admissionController.initContainer.image.repository | string | `"ironbank/opensource/kyverno/kyvernopre"` | Image repository |
| admissionController.initContainer.image.tag | string | `"v1.12.6"` | Image tag If missing, defaults to image.tag |
| admissionController.initContainer.image.pullPolicy | string | `nil` | Image pull policy If missing, defaults to image.pullPolicy |
| admissionController.initContainer.resources.limits | object | `{"cpu":"100m","memory":"256Mi"}` | Pod resource limits |
| admissionController.initContainer.resources.requests | object | `{"cpu":"10m","memory":"64Mi"}` | Pod resource requests |
| admissionController.initContainer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001,"seccompProfile":{"type":"RuntimeDefault"}}` | Container security context |
| admissionController.initContainer.extraArgs | object | `{}` | Additional container args. |
| admissionController.initContainer.extraEnvVars | list | `[]` | Additional container environment variables. |
| admissionController.container.image.registry | string | `"registry1.dso.mil"` | Image registry |
| admissionController.container.image.repository | string | `"ironbank/opensource/kyverno"` | Image repository |
| admissionController.container.image.tag | string | `"v1.12.6"` | Image tag Defaults to appVersion in Chart.yaml if omitted |
| admissionController.container.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| admissionController.container.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| admissionController.container.resources.limits | object | `{"cpu":"500m","memory":"512Mi"}` | Pod resource limits |
| admissionController.container.resources.requests | object | `{"cpu":"500m","memory":"512Mi"}` | Pod resource requests |
| admissionController.container.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001,"seccompProfile":{"type":"RuntimeDefault"}}` | Container security context |
| admissionController.container.extraArgs | object | `{}` | Additional container args. |
| admissionController.container.extraEnvVars | list | `[]` | Additional container environment variables. |
| admissionController.extraInitContainers | list | `[]` | Array of extra init containers |
| admissionController.extraContainers | list | `[]` | Array of extra containers to run alongside kyverno |
| admissionController.service.port | int | `443` | Service port. |
| admissionController.service.type | string | `"ClusterIP"` | Service type. |
| admissionController.service.nodePort | string | `nil` | Service node port. Only used if `type` is `NodePort`. |
| admissionController.service.annotations | object | `{}` | Service annotations. |
| admissionController.metricsService.create | bool | `true` | Create service. |
| admissionController.metricsService.port | int | `8000` | Service port. Kyverno's metrics server will be exposed at this port. |
| admissionController.metricsService.type | string | `"ClusterIP"` | Service type. |
| admissionController.metricsService.nodePort | string | `nil` | Service node port. Only used if `type` is `NodePort`. |
| admissionController.metricsService.annotations | object | `{}` | Service annotations. |
| admissionController.networkPolicy.enabled | bool | `false` | When true, use a NetworkPolicy to allow ingress to the webhook This is useful on clusters using Calico and/or native k8s network policies in a default-deny setup. |
| admissionController.networkPolicy.ingressFrom | list | `[]` | A list of valid from selectors according to <https://kubernetes.io/docs/concepts/services-networking/network-policies>. |
| admissionController.serviceMonitor.enabled | bool | `false` | Create a `ServiceMonitor` to collect Prometheus metrics. |
| admissionController.serviceMonitor.additionalLabels | object | `{}` | Additional labels |
| admissionController.serviceMonitor.namespace | string | `nil` | Override namespace |
| admissionController.serviceMonitor.interval | string | `"30s"` | Interval to scrape metrics |
| admissionController.serviceMonitor.scrapeTimeout | string | `"25s"` | Timeout if metrics can't be retrieved in given time interval |
| admissionController.serviceMonitor.secure | bool | `false` | Is TLS required for endpoint |
| admissionController.serviceMonitor.tlsConfig | object | `{}` | TLS Configuration for endpoint |
| admissionController.serviceMonitor.relabelings | list | `[]` | RelabelConfigs to apply to samples before scraping |
| admissionController.serviceMonitor.metricRelabelings | list | `[]` | MetricRelabelConfigs to apply to samples before ingestion. |
| admissionController.tracing.enabled | bool | `false` | Enable tracing |
| admissionController.tracing.address | string | `nil` | Traces receiver address |
| admissionController.tracing.port | string | `nil` | Traces receiver port |
| admissionController.tracing.creds | string | `""` | Traces receiver credentials |
| admissionController.metering.disabled | bool | `false` | Disable metrics export |
| admissionController.metering.config | string | `"prometheus"` | Otel configuration, can be `prometheus` or `grpc` |
| admissionController.metering.port | int | `8000` | Prometheus endpoint port |
| admissionController.metering.collector | string | `""` | Otel collector endpoint |
| admissionController.metering.creds | string | `""` | Otel collector credentials |
| admissionController.profiling.enabled | bool | `false` | Enable profiling |
| admissionController.profiling.port | int | `6060` | Profiling endpoint port |
| admissionController.profiling.serviceType | string | `"ClusterIP"` | Service type. |
| admissionController.profiling.nodePort | string | `nil` | Service node port. Only used if `type` is `NodePort`. |
| backgroundController.featuresOverride | object | `{}` | Overrides features defined at the root level |
| backgroundController.enabled | bool | `true` | Enable background controller. |
| backgroundController.rbac.create | bool | `true` | Create RBAC resources |
| backgroundController.rbac.serviceAccount.name | string | `nil` | Service account name |
| backgroundController.rbac.serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount |
| backgroundController.rbac.serviceAccount.automountServiceAccountToken.enabled | bool | `false` |  |
| backgroundController.rbac.deployment.automountServiceAccountToken.enabled | bool | `true` |  |
| backgroundController.rbac.coreClusterRole.extraResources | list | See [values.yaml](values.yaml) | Extra resource permissions to add in the core cluster role. This was introduced to avoid breaking change in the chart but should ideally be moved in `clusterRole.extraResources`. |
| backgroundController.rbac.clusterRole.extraResources | list | `[]` | Extra resource permissions to add in the cluster role |
| backgroundController.image.registry | string | `"registry1.dso.mil"` | Image registry |
| backgroundController.image.repository | string | `"ironbank/opensource/kyverno/kyverno/background-controller"` | Image repository |
| backgroundController.image.tag | string | `"v1.12.6"` | Image tag Defaults to appVersion in Chart.yaml if omitted |
| backgroundController.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| backgroundController.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| backgroundController.replicas | int | `nil` | Desired number of pods |
| backgroundController.revisionHistoryLimit | int | `10` | The number of revisions to keep |
| backgroundController.podLabels | object | `{}` | Additional labels to add to each pod |
| backgroundController.podAnnotations | object | `{}` | Additional annotations to add to each pod |
| backgroundController.updateStrategy | object | See [values.yaml](values.yaml) | Deployment update strategy. Ref: <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy> |
| backgroundController.priorityClassName | string | `""` | Optional priority class |
| backgroundController.hostNetwork | bool | `false` | Change `hostNetwork` to `true` when you want the pod to share its host's network namespace. Useful for situations like when you end up dealing with a custom CNI over Amazon EKS. Update the `dnsPolicy` accordingly as well to suit the host network mode. |
| backgroundController.dnsPolicy | string | `"ClusterFirst"` | `dnsPolicy` determines the manner in which DNS resolution happens in the cluster. In case of `hostNetwork: true`, usually, the `dnsPolicy` is suitable to be `ClusterFirstWithHostNet`. For further reference: <https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy>. |
| backgroundController.extraArgs | object | `{}` | Extra arguments passed to the container on the command line |
| backgroundController.extraEnvVars | list | `[]` | Additional container environment variables. |
| backgroundController.resources.limits | object | `{"memory":"128Mi"}` | Pod resource limits |
| backgroundController.resources.requests | object | `{"cpu":"100m","memory":"64Mi"}` | Pod resource requests |
| backgroundController.nodeSelector | object | `{}` | Node labels for pod assignment |
| backgroundController.tolerations | list | `[]` | List of node taints to tolerate |
| backgroundController.antiAffinity.enabled | bool | `true` | Pod antiAffinities toggle. Enabled by default but can be disabled if you want to schedule pods to the same node. |
| backgroundController.podAntiAffinity | object | See [values.yaml](values.yaml) | Pod anti affinity constraints. |
| backgroundController.podAffinity | object | `{}` | Pod affinity constraints. |
| backgroundController.nodeAffinity | object | `{}` | Node affinity constraints. |
| backgroundController.topologySpreadConstraints | list | `[]` | Topology spread constraints. |
| backgroundController.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context for the pod |
| backgroundController.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the containers |
| backgroundController.podDisruptionBudget.enabled | bool | `false` | Enable PodDisruptionBudget. Will always be enabled if replicas > 1. This non-declarative behavior should ideally be avoided, but changing it now would be breaking. |
| backgroundController.podDisruptionBudget.minAvailable | int | `1` | Configures the minimum available pods for disruptions. Cannot be used if `maxUnavailable` is set. |
| backgroundController.podDisruptionBudget.maxUnavailable | string | `nil` | Configures the maximum unavailable pods for disruptions. Cannot be used if `minAvailable` is set. |
| backgroundController.caCertificates.data | string | `nil` | CA certificates to use with Kyverno deployments This value is expected to be one large string of CA certificates |
| backgroundController.caCertificates.volume | object | `{}` | Volume to be mounted for CA certificates Not used when `.Values.backgroundController.caCertificates.data` is defined |
| backgroundController.metricsService.create | bool | `true` | Create service. |
| backgroundController.metricsService.port | int | `8000` | Service port. Metrics server will be exposed at this port. |
| backgroundController.metricsService.type | string | `"ClusterIP"` | Service type. |
| backgroundController.metricsService.nodePort | string | `nil` | Service node port. Only used if `metricsService.type` is `NodePort`. |
| backgroundController.metricsService.annotations | object | `{}` | Service annotations. |
| backgroundController.networkPolicy.enabled | bool | `false` | When true, use a NetworkPolicy to allow ingress to the webhook This is useful on clusters using Calico and/or native k8s network policies in a default-deny setup. |
| backgroundController.networkPolicy.ingressFrom | list | `[]` | A list of valid from selectors according to <https://kubernetes.io/docs/concepts/services-networking/network-policies>. |
| backgroundController.serviceMonitor.enabled | bool | `false` | Create a `ServiceMonitor` to collect Prometheus metrics. |
| backgroundController.serviceMonitor.additionalLabels | object | `{}` | Additional labels |
| backgroundController.serviceMonitor.namespace | string | `nil` | Override namespace |
| backgroundController.serviceMonitor.interval | string | `"30s"` | Interval to scrape metrics |
| backgroundController.serviceMonitor.scrapeTimeout | string | `"25s"` | Timeout if metrics can't be retrieved in given time interval |
| backgroundController.serviceMonitor.secure | bool | `false` | Is TLS required for endpoint |
| backgroundController.serviceMonitor.tlsConfig | object | `{}` | TLS Configuration for endpoint |
| backgroundController.serviceMonitor.relabelings | list | `[]` | RelabelConfigs to apply to samples before scraping |
| backgroundController.serviceMonitor.metricRelabelings | list | `[]` | MetricRelabelConfigs to apply to samples before ingestion. |
| backgroundController.tracing.enabled | bool | `false` | Enable tracing |
| backgroundController.tracing.address | string | `nil` | Traces receiver address |
| backgroundController.tracing.port | string | `nil` | Traces receiver port |
| backgroundController.tracing.creds | string | `""` | Traces receiver credentials |
| backgroundController.metering.disabled | bool | `false` | Disable metrics export |
| backgroundController.metering.config | string | `"prometheus"` | Otel configuration, can be `prometheus` or `grpc` |
| backgroundController.metering.port | int | `8000` | Prometheus endpoint port |
| backgroundController.metering.collector | string | `""` | Otel collector endpoint |
| backgroundController.metering.creds | string | `""` | Otel collector credentials |
| backgroundController.profiling.enabled | bool | `false` | Enable profiling |
| backgroundController.profiling.port | int | `6060` | Profiling endpoint port |
| backgroundController.profiling.serviceType | string | `"ClusterIP"` | Service type. |
| backgroundController.profiling.nodePort | string | `nil` | Service node port. Only used if `type` is `NodePort`. |
| cleanupController.featuresOverride | object | `{}` | Overrides features defined at the root level |
| cleanupController.enabled | bool | `true` | Enable cleanup controller. |
| cleanupController.rbac.create | bool | `true` | Create RBAC resources |
| cleanupController.rbac.serviceAccount.name | string | `nil` | Service account name |
| cleanupController.rbac.serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount |
| cleanupController.rbac.serviceAccount.automountServiceAccountToken.enabled | bool | `false` |  |
| cleanupController.rbac.deployment.automountServiceAccountToken.enabled | bool | `true` |  |
| cleanupController.rbac.clusterRole.extraResources | list | `[]` | Extra resource permissions to add in the cluster role |
| cleanupController.createSelfSignedCert | bool | `false` | Create self-signed certificates at deployment time. The certificates won't be automatically renewed if this is set to `true`. |
| cleanupController.image.registry | string | `"registry1.dso.mil"` | Image registry |
| cleanupController.image.repository | string | `"ironbank/opensource/kyverno/kyverno/cleanup-controller"` | Image repository |
| cleanupController.image.tag | string | `"v1.12.6"` | Image tag Defaults to appVersion in Chart.yaml if omitted |
| cleanupController.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| cleanupController.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| cleanupController.replicas | int | `nil` | Desired number of pods |
| cleanupController.revisionHistoryLimit | int | `10` | The number of revisions to keep |
| cleanupController.podLabels | object | `{}` | Additional labels to add to each pod |
| cleanupController.podAnnotations | object | `{}` | Additional annotations to add to each pod |
| cleanupController.updateStrategy | object | See [values.yaml](values.yaml) | Deployment update strategy. Ref: <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy> |
| cleanupController.priorityClassName | string | `""` | Optional priority class |
| cleanupController.hostNetwork | bool | `false` | Change `hostNetwork` to `true` when you want the pod to share its host's network namespace. Useful for situations like when you end up dealing with a custom CNI over Amazon EKS. Update the `dnsPolicy` accordingly as well to suit the host network mode. |
| cleanupController.server | object | `{"port":9443}` | cleanupController server port in case you are using hostNetwork: true, you might want to change the port the cleanupController is listening to |
| cleanupController.webhookServer | object | `{"port":9443}` | cleanupController webhook server port in case you are using hostNetwork: true, you might want to change the port the webhookServer is listening to |
| cleanupController.dnsPolicy | string | `"ClusterFirst"` | `dnsPolicy` determines the manner in which DNS resolution happens in the cluster. In case of `hostNetwork: true`, usually, the `dnsPolicy` is suitable to be `ClusterFirstWithHostNet`. For further reference: <https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy>. |
| cleanupController.extraArgs | object | `{}` | Extra arguments passed to the container on the command line |
| cleanupController.extraEnvVars | list | `[]` | Additional container environment variables. |
| cleanupController.resources.limits | object | `{"memory":"128Mi"}` | Pod resource limits |
| cleanupController.resources.requests | object | `{"cpu":"100m","memory":"64Mi"}` | Pod resource requests |
| cleanupController.startupProbe | object | See [values.yaml](values.yaml) | Startup probe. The block is directly forwarded into the deployment, so you can use whatever startupProbes configuration you want. ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/> |
| cleanupController.livenessProbe | object | See [values.yaml](values.yaml) | Liveness probe. The block is directly forwarded into the deployment, so you can use whatever livenessProbe configuration you want. ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/> |
| cleanupController.readinessProbe | object | See [values.yaml](values.yaml) | Readiness Probe. The block is directly forwarded into the deployment, so you can use whatever readinessProbe configuration you want. ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/> |
| cleanupController.nodeSelector | object | `{}` | Node labels for pod assignment |
| cleanupController.tolerations | list | `[]` | List of node taints to tolerate |
| cleanupController.antiAffinity.enabled | bool | `true` | Pod antiAffinities toggle. Enabled by default but can be disabled if you want to schedule pods to the same node. |
| cleanupController.podAntiAffinity | object | See [values.yaml](values.yaml) | Pod anti affinity constraints. |
| cleanupController.podAffinity | object | `{}` | Pod affinity constraints. |
| cleanupController.nodeAffinity | object | `{}` | Node affinity constraints. |
| cleanupController.topologySpreadConstraints | list | `[]` | Topology spread constraints. |
| cleanupController.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context for the pod |
| cleanupController.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the containers |
| cleanupController.podDisruptionBudget.enabled | bool | `false` | Enable PodDisruptionBudget. Will always be enabled if replicas > 1. This non-declarative behavior should ideally be avoided, but changing it now would be breaking. |
| cleanupController.podDisruptionBudget.minAvailable | int | `1` | Configures the minimum available pods for disruptions. Cannot be used if `maxUnavailable` is set. |
| cleanupController.podDisruptionBudget.maxUnavailable | string | `nil` | Configures the maximum unavailable pods for disruptions. Cannot be used if `minAvailable` is set. |
| cleanupController.service.port | int | `443` | Service port. |
| cleanupController.service.type | string | `"ClusterIP"` | Service type. |
| cleanupController.service.nodePort | string | `nil` | Service node port. Only used if `service.type` is `NodePort`. |
| cleanupController.service.annotations | object | `{}` | Service annotations. |
| cleanupController.metricsService.create | bool | `true` | Create service. |
| cleanupController.metricsService.port | int | `8000` | Service port. Metrics server will be exposed at this port. |
| cleanupController.metricsService.type | string | `"ClusterIP"` | Service type. |
| cleanupController.metricsService.nodePort | string | `nil` | Service node port. Only used if `metricsService.type` is `NodePort`. |
| cleanupController.metricsService.annotations | object | `{}` | Service annotations. |
| cleanupController.networkPolicy.enabled | bool | `false` | When true, use a NetworkPolicy to allow ingress to the webhook This is useful on clusters using Calico and/or native k8s network policies in a default-deny setup. |
| cleanupController.networkPolicy.ingressFrom | list | `[]` | A list of valid from selectors according to <https://kubernetes.io/docs/concepts/services-networking/network-policies>. |
| cleanupController.serviceMonitor.enabled | bool | `false` | Create a `ServiceMonitor` to collect Prometheus metrics. |
| cleanupController.serviceMonitor.additionalLabels | object | `{}` | Additional labels |
| cleanupController.serviceMonitor.namespace | string | `nil` | Override namespace |
| cleanupController.serviceMonitor.interval | string | `"30s"` | Interval to scrape metrics |
| cleanupController.serviceMonitor.scrapeTimeout | string | `"25s"` | Timeout if metrics can't be retrieved in given time interval |
| cleanupController.serviceMonitor.secure | bool | `false` | Is TLS required for endpoint |
| cleanupController.serviceMonitor.tlsConfig | object | `{}` | TLS Configuration for endpoint |
| cleanupController.serviceMonitor.relabelings | list | `[]` | RelabelConfigs to apply to samples before scraping |
| cleanupController.serviceMonitor.metricRelabelings | list | `[]` | MetricRelabelConfigs to apply to samples before ingestion. |
| cleanupController.tracing.enabled | bool | `false` | Enable tracing |
| cleanupController.tracing.address | string | `nil` | Traces receiver address |
| cleanupController.tracing.port | string | `nil` | Traces receiver port |
| cleanupController.tracing.creds | string | `""` | Traces receiver credentials |
| cleanupController.metering.disabled | bool | `false` | Disable metrics export |
| cleanupController.metering.config | string | `"prometheus"` | Otel configuration, can be `prometheus` or `grpc` |
| cleanupController.metering.port | int | `8000` | Prometheus endpoint port |
| cleanupController.metering.collector | string | `""` | Otel collector endpoint |
| cleanupController.metering.creds | string | `""` | Otel collector credentials |
| cleanupController.profiling.enabled | bool | `false` | Enable profiling |
| cleanupController.profiling.port | int | `6060` | Profiling endpoint port |
| cleanupController.profiling.serviceType | string | `"ClusterIP"` | Service type. |
| cleanupController.profiling.nodePort | string | `nil` | Service node port. Only used if `type` is `NodePort`. |
| reportsController.featuresOverride | object | `{}` | Overrides features defined at the root level |
| reportsController.enabled | bool | `true` | Enable reports controller. |
| reportsController.rbac.create | bool | `true` | Create RBAC resources |
| reportsController.rbac.serviceAccount.name | string | `nil` | Service account name |
| reportsController.rbac.serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount |
| reportsController.rbac.serviceAccount.automountServiceAccountToken.enabled | bool | `false` |  |
| reportsController.rbac.deployment.automountServiceAccountToken.enabled | bool | `true` |  |
| reportsController.rbac.coreClusterRole.extraResources | list | See [values.yaml](values.yaml) | Extra resource permissions to add in the core cluster role. This was introduced to avoid breaking change in the chart but should ideally be moved in `clusterRole.extraResources`. |
| reportsController.rbac.clusterRole.extraResources | list | `[]` | Extra resource permissions to add in the cluster role |
| reportsController.image.registry | string | `"registry1.dso.mil"` | Image registry |
| reportsController.image.repository | string | `"ironbank/opensource/kyverno/kyverno/reports-controller"` | Image repository |
| reportsController.image.tag | string | `"v1.12.6"` | Image tag Defaults to appVersion in Chart.yaml if omitted |
| reportsController.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| reportsController.imagePullSecrets | list | `[{"name":"private-registry"}]` | Image pull secrets |
| reportsController.replicas | int | `nil` | Desired number of pods |
| reportsController.revisionHistoryLimit | int | `10` | The number of revisions to keep |
| reportsController.podLabels | object | `{}` | Additional labels to add to each pod |
| reportsController.podAnnotations | object | `{}` | Additional annotations to add to each pod |
| reportsController.updateStrategy | object | See [values.yaml](values.yaml) | Deployment update strategy. Ref: <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy> |
| reportsController.priorityClassName | string | `""` | Optional priority class |
| reportsController.apiPriorityAndFairness | bool | `false` | Change `apiPriorityAndFairness` to `true` if you want to insulate the API calls made by Kyverno reports controller activities. This will help ensure Kyverno reports stability in busy clusters. Ref: <https://kubernetes.io/docs/concepts/cluster-administration/flow-control/> |
| reportsController.priorityLevelConfigurationSpec | object | See [values.yaml](values.yaml) | Priority level configuration. The block is directly forwarded into the priorityLevelConfiguration, so you can use whatever specification you want. ref: <https://kubernetes.io/docs/concepts/cluster-administration/flow-control/#prioritylevelconfiguration> |
| reportsController.hostNetwork | bool | `false` | Change `hostNetwork` to `true` when you want the pod to share its host's network namespace. Useful for situations like when you end up dealing with a custom CNI over Amazon EKS. Update the `dnsPolicy` accordingly as well to suit the host network mode. |
| reportsController.dnsPolicy | string | `"ClusterFirst"` | `dnsPolicy` determines the manner in which DNS resolution happens in the cluster. In case of `hostNetwork: true`, usually, the `dnsPolicy` is suitable to be `ClusterFirstWithHostNet`. For further reference: <https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy>. |
| reportsController.extraArgs | object | `{}` | Extra arguments passed to the container on the command line |
| reportsController.extraEnvVars | list | `[]` | Additional container environment variables. |
| reportsController.resources.limits | object | `{"memory":"128Mi"}` | Pod resource limits |
| reportsController.resources.requests | object | `{"cpu":"100m","memory":"64Mi"}` | Pod resource requests |
| reportsController.nodeSelector | object | `{}` | Node labels for pod assignment |
| reportsController.tolerations | list | `[]` | List of node taints to tolerate |
| reportsController.antiAffinity.enabled | bool | `true` | Pod antiAffinities toggle. Enabled by default but can be disabled if you want to schedule pods to the same node. |
| reportsController.podAntiAffinity | object | See [values.yaml](values.yaml) | Pod anti affinity constraints. |
| reportsController.podAffinity | object | `{}` | Pod affinity constraints. |
| reportsController.nodeAffinity | object | `{}` | Node affinity constraints. |
| reportsController.topologySpreadConstraints | list | `[]` | Topology spread constraints. |
| reportsController.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context for the pod |
| reportsController.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the containers |
| reportsController.podDisruptionBudget.enabled | bool | `false` | Enable PodDisruptionBudget. Will always be enabled if replicas > 1. This non-declarative behavior should ideally be avoided, but changing it now would be breaking. |
| reportsController.podDisruptionBudget.minAvailable | int | `1` | Configures the minimum available pods for disruptions. Cannot be used if `maxUnavailable` is set. |
| reportsController.podDisruptionBudget.maxUnavailable | string | `nil` | Configures the maximum unavailable pods for disruptions. Cannot be used if `minAvailable` is set. |
| reportsController.tufRootMountPath | string | `"/.sigstore"` | A writable volume to use for the TUF root initialization. |
| reportsController.sigstoreVolume | object | `{"emptyDir":{}}` | Volume to be mounted in pods for TUF/cosign work. |
| reportsController.caCertificates.data | string | `nil` | CA certificates to use with Kyverno deployments This value is expected to be one large string of CA certificates |
| reportsController.caCertificates.volume | object | `{}` | Volume to be mounted for CA certificates Not used when `.Values.reportsController.caCertificates.data` is defined |
| reportsController.metricsService.create | bool | `true` | Create service. |
| reportsController.metricsService.port | int | `8000` | Service port. Metrics server will be exposed at this port. |
| reportsController.metricsService.type | string | `"ClusterIP"` | Service type. |
| reportsController.metricsService.nodePort | string | `nil` | Service node port. Only used if `type` is `NodePort`. |
| reportsController.metricsService.annotations | object | `{}` | Service annotations. |
| reportsController.networkPolicy.enabled | bool | `false` | When true, use a NetworkPolicy to allow ingress to the webhook This is useful on clusters using Calico and/or native k8s network policies in a default-deny setup. |
| reportsController.networkPolicy.ingressFrom | list | `[]` | A list of valid from selectors according to <https://kubernetes.io/docs/concepts/services-networking/network-policies>. |
| reportsController.serviceMonitor.enabled | bool | `false` | Create a `ServiceMonitor` to collect Prometheus metrics. |
| reportsController.serviceMonitor.additionalLabels | object | `{}` | Additional labels |
| reportsController.serviceMonitor.namespace | string | `nil` | Override namespace |
| reportsController.serviceMonitor.interval | string | `"30s"` | Interval to scrape metrics |
| reportsController.serviceMonitor.scrapeTimeout | string | `"25s"` | Timeout if metrics can't be retrieved in given time interval |
| reportsController.serviceMonitor.secure | bool | `false` | Is TLS required for endpoint |
| reportsController.serviceMonitor.tlsConfig | object | `{}` | TLS Configuration for endpoint |
| reportsController.serviceMonitor.relabelings | list | `[]` | RelabelConfigs to apply to samples before scraping |
| reportsController.serviceMonitor.metricRelabelings | list | `[]` | MetricRelabelConfigs to apply to samples before ingestion. |
| reportsController.tracing.enabled | bool | `false` | Enable tracing |
| reportsController.tracing.address | string | `nil` | Traces receiver address |
| reportsController.tracing.port | string | `nil` | Traces receiver port |
| reportsController.tracing.creds | string | `nil` | Traces receiver credentials |
| reportsController.metering.disabled | bool | `false` | Disable metrics export |
| reportsController.metering.config | string | `"prometheus"` | Otel configuration, can be `prometheus` or `grpc` |
| reportsController.metering.port | int | `8000` | Prometheus endpoint port |
| reportsController.metering.collector | string | `nil` | Otel collector endpoint |
| reportsController.metering.creds | string | `nil` | Otel collector credentials |
| reportsController.profiling.enabled | bool | `false` | Enable profiling |
| reportsController.profiling.port | int | `6060` | Profiling endpoint port |
| reportsController.profiling.serviceType | string | `"ClusterIP"` | Service type. |
| reportsController.profiling.nodePort | string | `nil` | Service node port. Only used if `type` is `NodePort`. |
| bbtests | object | `{"enabled":false,"imagePullSecret":"private-registry","scripts":{"additionalVolumeMounts":[{"mountPath":"/yaml","name":"kyverno-policies-bbtest-manifests"},{"mountPath":"/.kube/cache","name":"kyverno-policies-bbtest-kube-cache"}],"additionalVolumes":[{"configMap":{"name":"kyverno-policies-bbtest-manifests"},"name":"kyverno-policies-bbtest-manifests"},{"emptyDir":{},"name":"kyverno-policies-bbtest-kube-cache"}],"envs":{"ENABLED_POLICIES":"{{ $p := list }}{{ range $k, $v := .Values.policies }}{{ if $v.enabled }}{{ $p = append $p $k }}{{ end }}{{ end }}{{ join \" \" $p }}","IMAGE_PULL_SECRET":"{{ .Values.bbtests.imagePullSecret }}","KYVERNO_INSTALL":"{{ .Values.kyverno.install }}","KYVERNO_NAMESPACE":"{{ .Release.Namespace }}"},"image":"registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.30.5"}}` | Reserved values for Big Bang test automation |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.

---

_This file is programatically generated using `helm-docs` and some BigBang-specific templates. The `gluon` repository has [instructions for regenerating package READMEs](https://repo1.dso.mil/big-bang/product/packages/gluon/-/blob/master/docs/bb-package-readme.md)._
