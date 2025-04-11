<!-- Warning: Do not manually edit this file. See notes on gluon + helm-docs at the end of this file for more information. -->
# kyverno-policies

![Version: 3.3.4-bb.8](https://img.shields.io/badge/Version-3.3.4--bb.8-informational?style=flat-square) ![AppVersion: v1.13.2](https://img.shields.io/badge/AppVersion-v1.13.2-informational?style=flat-square) ![Maintenance Track: bb_integrated](https://img.shields.io/badge/Maintenance_Track-bb_integrated-green?style=flat-square)

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
| waitforready.enabled | bool | `false` | Controls wait for ready deployment |
| waitforready.image | object | `{"repository":"registry1.dso.mil/ironbank/opensource/kubernetes/kubectl","tag":"v1.30.11"}` | Image to use in wait for ready job.  This must contain kubectl. |
| waitforready.imagePullSecrets | list | `[]` | Pull secret for wait for ready job |
| policies.sample | object | `{"enabled":false,"exclude":{},"match":{},"parameters":{"excludeContainers":[]},"validationFailureAction":"Audit","webhookTimeoutSeconds":""}` | Sample policy showing values that can be added to any policy |
| policies.sample.enabled | bool | `false` | Controls policy deployment |
| policies.sample.validationFailureAction | string | `"Audit"` | Controls if a validation policy rule failure should disallow (Enforce) or allow (Audit) the admission |
| policies.sample.webhookTimeoutSeconds | string | `""` | Specifies the maximum time in seconds allowed to apply this policy. Default is 10. Range is 1 to 30. |
| policies.sample.match | object | `{}` | Defines when this policy's rules should be applied.  This completely overrides any default matches. |
| policies.sample.exclude | object | `{}` | Defines when this policy's rules should not be applied.  This completely overrides any default excludes. |
| policies.sample.parameters | object | `{"excludeContainers":[]}` | Policy specific parameters that are added to the configMap for the policy rules |
| policies.sample.parameters.excludeContainers | list | `[]` | Adds a container exclusion (by name) to a specific policy.  This is merged with any global excludeContainers. |
| policies.block-ephemeral-containers.enabled | bool | `true` |  |
| policies.block-ephemeral-containers.validationFailureAction | string | `"Enforce"` |  |
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
| policies.require-labels | object | `{"enabled":true,"parameters":{"require":["app.kubernetes.io/name","app.kubernetes.io/instance","app.kubernetes.io/version"]},"validationFailureAction":"Audit"}` | Require specified labels to be on all pods |
| policies.require-labels.parameters.require | list | `["app.kubernetes.io/name","app.kubernetes.io/instance","app.kubernetes.io/version"]` | List of labels required on all pods.  Entries can be just a "key", or a quoted "key: value".  Wildcards '*' and '?' are supported. See <https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels> See <https://helm.sh/docs/chart_best_practices/labels/#standard-labels> |
| policies.require-memory-limit | object | `{"enabled":false,"parameters":{"require":["<64Gi"]},"validationFailureAction":"Audit"}` | Require containers have memory limits defined and within the specified range |
| policies.require-memory-limit.parameters.require | list | `["<64Gi"]` | Memory limitations (only one required condition needs to be met).  Can use standard Kubernetes resource units (e.g. Mi, Gi).  The following operators are valid: >, <, >=, <=, !, \|, &. |
| policies.add-default-capability-drop | object | `{"enabled":true,"validationFailureAction":"Enforce"}` | This policy will mutate a Pod to set `spec.(initEphemeralC\|c)ontainers[].securityContext.capabilities.drop` to 'ALL' if it is not already set. |
| policies.add-default-securitycontext | object | `{"enabled":true,"validationFailureAction":"Enforce"}` | This policy will mutate a Pod to set `runAsNonRoot`, `runAsUser`, `runAsGroup`, and `fsGroup` fields within the Pod securityContext if they are not already set. |
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
| policies.restrict-group-id.parameters.allow | list | `[">=1000"]` | Allowed group IDs / ranges.  The following operators are valid: ">, <, >=, <=, !, \|, &." For a lower and upper limit, use ">=min & <=max" |
| policies.restrict-host-path-mount | object | `{"enabled":true,"parameters":{"allow":[]},"validationFailureAction":"Audit"}` | Restrict the paths that can be mounted by hostPath volumes to the allowed list.  HostPath volumes are normally disallowed.  If exceptions are made, the path(s) should be restricted. |
| policies.restrict-host-path-mount.parameters.allow | list | `[]` | List of allowed paths for hostPath volumes to mount |
| policies.restrict-host-path-mount-pv.enabled | bool | `true` |  |
| policies.restrict-host-path-mount-pv.validationFailureAction | string | `"Audit"` |  |
| policies.restrict-host-path-mount-pv.parameters.allow | list | `[]` | List of allowed paths for hostPath volumes to mount |
| policies.restrict-host-path-write | object | `{"enabled":true,"parameters":{"allow":[]},"validationFailureAction":"Audit"}` | Restrict the paths that can be mounted as read/write by hostPath volumes to the allowed list.  HostPath volumes, if allowed, should normally be mounted as read-only.  If exceptions are made, the path(s) should be restricted. |
| policies.restrict-host-path-write.parameters.allow | list | `[]` | List of allowed paths for hostPath volumes to mount as read/write |
| policies.restrict-host-ports | object | `{"enabled":true,"parameters":{"allow":[]},"validationFailureAction":"Enforce"}` | Restrict host ports in containers to the specified list |
| policies.restrict-host-ports.parameters.allow | list | `[]` | List of allowed host ports |
| policies.restrict-image-registries | object | `{"enabled":true,"parameters":{"allow":["registry1.dso.mil/"]},"validationFailureAction":"Audit"}` | Restricts container images to registries in the specified list |
| policies.restrict-image-registries.parameters.allow | list | `["registry1.dso.mil/"]` | List of allowed registries that images may use |
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
| additionalPolicyExceptions | object | `{"samplePolicyException":{"annotations":{"policies.kyverno.io/category":"Examples","policies.kyverno.io/description":"This sample PolicyException allows pods from deploying busybox for debugging.","policies.kyverno.io/subject":"Pod","policies.kyverno.io/title":"Sample PolicyException"},"enabled":false,"kind":"PolicyException","namespace":""}}` | Adds additional policyExceptions.  See <https://kyverno.io/docs/writing-policies/exceptions/> |
| additionalPolicyExceptions.samplePolicyException | object | `{"annotations":{"policies.kyverno.io/category":"Examples","policies.kyverno.io/description":"This sample PolicyException allows pods from deploying busybox for debugging.","policies.kyverno.io/subject":"Pod","policies.kyverno.io/title":"Sample PolicyException"},"enabled":false,"kind":"PolicyException","namespace":""}` | Name of the policy.  Addtional policyexceptions can be added by adding a key. |
| additionalPolicyExceptions.samplePolicyException.enabled | bool | `false` | Controls policy deployment |
| additionalPolicyExceptions.samplePolicyException.kind | string | `"PolicyException"` | Kind of PolicyException |
| additionalPolicyExceptions.samplePolicyException.namespace | string | `""` | If kind is "PolicyException", which namespace to target.  The namespace must already exist. |
| additionalPolicyExceptions.samplePolicyException.annotations | object | `{"policies.kyverno.io/category":"Examples","policies.kyverno.io/description":"This sample PolicyException allows pods from deploying busybox for debugging.","policies.kyverno.io/subject":"Pod","policies.kyverno.io/title":"Sample PolicyException"}` | Policy annotations to add |
| additionalPolicyExceptions.samplePolicyException.annotations."policies.kyverno.io/title" | string | `"Sample PolicyException"` | Human readable name of policyException |
| additionalPolicyExceptions.samplePolicyException.annotations."policies.kyverno.io/category" | string | `"Examples"` | Category of policy.  Arbitrary. |
| additionalPolicyExceptions.samplePolicyException.annotations."policies.kyverno.io/subject" | string | `"Pod"` | Type of resource PolicyException applies to (e.g. Pod, Service, Namespace) |
| additionalPolicyExceptions.samplePolicyException.annotations."policies.kyverno.io/description" | string | `"This sample PolicyException allows pods from deploying busybox for debugging."` | Description of why the PolicyException is necessary and what items are allowed or unallowed. |
| istio | object | `{"enabled":false}` | BigBang Istio Toggle and Configuration |
| bbtests | object | `{"enabled":false,"imagePullSecret":"private-registry","scripts":{"additionalVolumeMounts":[{"mountPath":"/yaml","name":"kyverno-policies-bbtest-manifests"},{"mountPath":"/.kube/cache","name":"kyverno-policies-bbtest-kube-cache"}],"additionalVolumes":[{"configMap":{"name":"kyverno-policies-bbtest-manifests"},"name":"kyverno-policies-bbtest-manifests"},{"emptyDir":{},"name":"kyverno-policies-bbtest-kube-cache"}],"envs":{"ENABLED_POLICIES":"{{ $p := list }}{{ range $k, $v := .Values.policies }}{{ if $v.enabled }}{{ $p = append $p $k }}{{ end }}{{ end }}{{ join \" \" $p }}","IMAGE_PULL_SECRET":"{{ .Values.bbtests.imagePullSecret }}"},"image":"registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.32.3"}}` | Reserved values for Big Bang test automation |
| waitJob.enabled | bool | `true` |  |
| waitJob.kind | string | `"ClusterRole"` |  |
| waitJob.scripts.image | string | `"registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.32.3"` |  |
| waitJob.permissions.apiGroups[0] | string | `"kyverno.io"` |  |
| waitJob.permissions.resources[0] | string | `"clusterpolicies"` |  |
| waitJob.permissions.resources[1] | string | `"policies"` |  |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.

---

_This file is programatically generated using `helm-docs` and some BigBang-specific templates. The `gluon` repository has [instructions for regenerating package READMEs](https://repo1.dso.mil/big-bang/product/packages/gluon/-/blob/master/docs/bb-package-readme.md)._
