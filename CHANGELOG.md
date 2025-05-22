# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

---
## [3.3.4-bb.9] - 2025-05-16

### Changed

- updated renovate.json


## [3.3.4-bb.9] - 2025-05-14

### Changed

- Removed waitforready job
- Updated gluon from 0.5.15 -> 0.5.19

## [3.3.4-bb.8] - 2025-04-11

### Changed

- Update Gatekeeper migration doc

## [3.3.4-bb.7] - 2025-04-04

### Changed

- Fix Gatekeeper migration docs that is inaccurate
- Updated Gluon from 0.5.14 -> 0.5.15
- Updated registry1.dso.mil/ironbank/opensource/kubernetes/kubectl from v1.30.10 -> v1.32.3

## [3.3.4-bb.6] - 2025-03-17

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.30.6 to v1.30.11
- ironbank/redhat/ubi/ubi9-minimal updated from 9.4 to 9.5

## [3.3.4-bb.5] - 2025-02-12

### Changed

- Fixed the default registry url to prevent subdomains from being used
- update gluon dependency chart -> v0.5.14

## [3.3.4-bb.4] - 2025-02-10

### Changed

- Edited `additionalPolicyExceptions` to be in kyverno-policies namespace.

## [3.3.4-bb.3] - 2025-01-21

### Changed

- Added `add-default-capability-drop` policy

## [3.3.4-bb.2] - 2024-12-15

### Changed

- Added `additionalPolicyExceptions` to values.yaml
- Added `additional-PolicyExceptions.yaml`

## [3.3.4-bb.1] - 2024-12-12

### Changed

- Added `add-a-default-securitycontext` policy and `test-defaultsecuritycontext.sh`

## [3.3.4-bb.0] - 2024-12-10

### Changed

- Updated chart from `kyverno-chart-3.2.6` to `kyverno-chart-3.3.4` and app version from `v1.12.6` to `v1.13.2`

## [3.2.6-bb.3] - 2024-12-03

### Changed

- Updated `require-labels` test manifest

## [3.2.6-bb.1] - 2024-10-23

### Changed

- Added `block-ephemeral-containers` policy and `test-ephemeral.sh` as test
- Added the maintenance track annotation and badge

## [3.2.6-bb.0] - 2024-10-09

### Changed

- `ironbank/opensource/kubernetes/kubectl` updated from `v1.29.7` to `v1.30.5`
- updated chart from `kyverno-chart-3.2.5` to `kyverno-chart-3.2.6` and app version from `v1.12.5` to `v1.12.6`
- updated `ironbank/opensource/kubernetes/kubectl` updated from `v1.29.7` to `v1.30.5`

## [3.2.5-bb.7] - 2024-09-16

### Changed

- add wait job
- update gluon from 0.5.3 to 0.5.4

## [3.2.5-bb.6] - 2024-09-09

### Changed

- update ironbank public container signing key

## [3.2.5-bb.5] - 2024-09-09

### Changed

- set generateExisting to false

## [3.2.5-bb.4] - 2024-08-20

### Changed

- Added GenerateExisting option for clone-config.yaml
- Updated gluon from 0.5.2 to 0.5.3

## [3.2.5-bb.3] - 2024-08-02

### Changed

- Added app and version to require-labels policy & update manifest

## [3.2.5-bb.2] - 2024-07-31

### Changed

- Updated chart/templates/exception-require-non-root-group.yaml:apiVersion: from `kyverno.io/v2beta1` to the latest version `kyverno.io/v2`
- chart/templates/exception-require-non-root-user.yaml:apiVersion: from `kyverno.io/v2beta1` to `kyverno.io/v2`
- chart/templates/update-automountserviceaccounttokens.yaml apiVersion:
  from `kyverno.io/v2beta1` to the latest version`kyverno.io/v2`

## [3.2.5-bb.1] - 2024-07-27

### Changed

- Gluon updated from `0.5.0` to `0.5.2`
- `ironbank/opensource/kubernetes/kubectl` updated from `v1.29.4` to `v1.29.7`

## [3.2.5-bb.0] - 2024-07-23

### Changed

- Updated versions in version and annotations under Chart.yaml to match Kyverno chart that we are currently using - 3.2.5

## [3.2.3-bb.0] - 2024-07-18

### Changed

- update helm chart from `kyverno-chart-3.0.4` to `kyverno-chart-3.2.3` and app version from `v1.11.0` to `v1.12.3`

## [3.0.4-bb.34] - 2024-07-16

### Changed

- Added metadata annotation to disallow-istio-injection-bypass policy

## [3.0.4-bb.33] - 2024-06-17

### Changed

- Fixed error in execption-require-non-root-group.yaml and in the non-root-user.yaml

## [3.0.4-bb.32] - 2024-05-23

### Changed

- setting autogen rules to `Deployment,ReplicaSet,DaemonSet,StatefulSet` as default to mitagate false positive behavior

## [3.0.4-bb.31] - 2024-05-16

### Changed

- updated commentted example in values.yaml file for `update-automountserviceaccounttokens:`

## [3.0.4-bb.30] - 2024-05-03

### Changed

- gluon updated from 0.4.8 to 0.5.0
- ironbank/opensource/kubernetes/kubectl updated from v1.29.3 to v1.29.4
- ironbank/redhat/ubi/ubi9-minimal updated from 9.3 to 9.4

## [3.0.4-bb.29] - 2024-04-19

### Changed

- Added support for checking deprecated API policy for Kubernetes v1.32.
- ironbank/opensource/kubernetes/kubectl updated from v1.28.7 to v1.29.3

## [3.0.4-bb.28] - 2024-03-20

### Changed

- Ensuring `kube-system` namespace is excluded from policy action

## [3.0.4-bb.27] - 2024-03-07

### Changed

- Removed duplicate `pod-policies.kyverno.io/autogen-controllers` annotation is disallow-tolerations ClusterPolicy.

## [3.0.4-bb.26] - 2024-02-29

### Changed

- Fixed audit and mutator for AutomountServiceAccountTokens for StatefulSet and Deployments

## [3.0.4-bb.25] - 2024-02-20

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.28.6 to v1.28.7
- gluon chart updated from 0.3.1 to 0.4.8

## [3.0.4-bb.24] - 2024-01-31

### Changed

- Updated allowed `sysctls` per Pod Security Standards

## [3.0.4-bb.23] - 2024-01-30

### Changed

- Fixed issue with kyverno policy related to wildcarding serviceAccounts in the automountServiceAccountToken clusterPolicy

## [3.0.4-bb.22] - 2024-01-29

### Changed

- Hardcoded annotation pod-policies.kyverno.io/autogen-controllers removed from disallowed-namespaces ClusterPolicy.
- Default value for {{.Values.autogenController}} set to none instead of empty string

## [3.0.4-bb.21] - 2024-01-26

### Changed

- Refactored PodsToHarden format

## [3.0.4-bb.20] - 2024-01-25

### Changed

- Fixed issue with kyverno policy related to wildcarding serviceAccounts in the automountServiceAccountToken clusterPolicy

## [3.0.4-bb.19] - 2024-01-19

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.28.4 to v1.28.6
- ironbank/redhat/ubi/ubi9-minimal updated from 8.9 to 9.3

## [3.0.4-bb.18] - 2024-01-05

### Changed

- update to ironbank/redhat/ubi/ubi8-minimal to ironbank/redhat/ubi/ubi9-minimal

## [3.0.4-bb.17] - 2023-12-21

### Changed

- Fixed issue with kyverno policy related to automountServiceAccountToken exemptions
- Added kyverno policy related to mutating pods with respect to automountServiceAccountToken hardening

## [3.0.4-bb.17] - 2023-12-21

### Changed

- Fixed issue with kyverno policy related to automountServiceAccountToken exemptions
- Added kyverno policy related to mutating pods with respect to automountServiceAccountToken hardening

## [3.0.4-bb.16] - 2023-12-15

### Changed

- add `ctlog.ignoreSCT: true` to `require-image-signature` policy

## [3.0.4-bb.15] - 2023-12-05

### Changed

- set `failurePolicy` to `Ignore` by default for audit policies with new helper function

## [3.0.4-bb.14] - 2023-12-04

### Changed

- Exclude default SA from serviceaccount mutation in update-automountserviceaccounttokens

## [3.0.4-bb.13] - 2023-12-01

### Changed

- Fix following upstream (Kyverno 1.11.0) changes in signature verification default behavior, adding new `ignoreTlog` and `url` fields to `require-image-signature` policy to ignore checking transaction logs for Iron Bank images.

## [3.0.4-bb.12] - 2023-11-17

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.28.3 to v1.28.4
- ironbank/redhat/ubi/ubi8-minimal updated from 8.8 to 8.9

## [3.0.4-bb.11] - 2023-11-15

### Changed

- Added support for checking deprecated API policy for Kubernetes v1.29.

## [3.0.4-bb.10] - 2023-11-13

### Changed

- Added ClusterPolicy to disable automountserviceaccounttoken on default serviceaccounts

## [3.0.4-bb.9] - 2023-11-09

### Added

- require-non-root-user-exception template for istio-init containers

## [3.0.4-bb.8] - 2023-11-07

### Added

- istio.enabled toggle for below PolicyException template
- require-non-root-group-exception template for istio-init containers

## [3.0.4-bb.7] - 2023-11-01

### Changed

- Fixed test for ClusterPolicy automountserviceaccounttoken

## [3.0.4-bb.6] - 2023-10-31

### Changed

- Default ClusterPolicy automountserviceaccounttoken to disabled

## [3.0.4-bb.5] - 2023-10-27

### Changed

- Added ClusterPolicy to disable automountserviceaccounttoken on the serviceaccounts and enable on the pods

## [3.0.4-bb.4] - 2023-10-25

### Changed

- Removed exceptions for Kyverno Reporter, Gitlab Runners, and Gitlab Shared Secrets (moved to bigbang repo)

## [3.0.4-bb.3] - 2023-10-22

### Changed

- ironbank/opensource/kubernetes/kubectl updated from 1.27.3 to v1.28.3

## [3.0.4-bb.2] - 2023-10-11

### Changed

- Added Kyverno Policy for Auditing Automount Service Account Token usage.
- Added exceptions for Kyverno Reporter, Gitlab Runners, and Gitlab Shared Secrets

## [3.0.4-bb.1] - 2023-10-11

### Changed

- respect `autogenControllers`, `background`, and `failurePolicy` values across all policies

## [3.0.4-bb.0] - 2023-09-20

### Changed

- changed CI test script and values to work better with newer kyverno chart version 3.0.0 for app version 1.10.X
- disabled require-non-root-group and require-non-root-user policy tests until a fix is added

## [1.1.0-bb.10] - 2023-08-29

### Added

- precondition support for excluding istio-init containers from require-group policy

## [1.1.0-bb.9] - 2023-08-01

### Added

- added DEVELOPMENT_MAINTENANCE.md

## [1.1.0-bb.8] - 2023-07-27

### Changed

- re-added IB key to test values for package/BB CI
- modified disallow-image-tags, require-image-signature, update-image-registry
- added timeout to test-policies.sh

## [1.1.0-bb.7] - 2023-06-16

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.26.4 to 1.27.3
- ironbank/redhat/ubi/ubi9-minimal updated from 8.7 to 8.8

## [1.1.0-bb.6] - 2023-04-15

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.26.3 to v1.26.4

## [1.1.0-bb.5] - 2023-03-30

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.26.2 to v1.26.3

## [1.1.0-bb.4] - 2023-03-29

### Changed

- modified enabled policy test to only run on package pipelines

## [1.1.0-bb.3] - 2023-03-04

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.26.1 to v1.26.2

## [1.1.0-bb.2] - 2023-02-07

### Changed

- Updated kubectl to v1.26.1
- Updated gluon to 0.3.2

## [1.1.0-bb.1] - 2023-01-26

### Changed

- Updated kubectl to v1.25.6
- Updated gluon to 0.3.1

## [1.1.0-bb.0] - 2023-01-11

### Changed

- Removed `disallow-shared-subpath-volume-writes` policy (no longer beneficial for any non-EOL k8s versions)
- Removed Ironbank key from test values

## [1.0.1-bb.12] - 20223-01-06

### Changed

- Added support for checking deprecated API policy for Kubernetes v1.27.

## [1.0.1-bb.11] - 2022-12-20

### Changed

- Updated default values for require-image-signature to align with upstream documentation

## [1.0.1-bb.10] - 2022-12-5

### Changed

- Changed values.yaml to fail images from ironbank that are not signed.

## [1.0.1-bb.9] - 2022-12-13

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.25.4 to v1.25.5

## [1.0.1-bb.8] - 2022-11-16

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.25.3 to v1.25.4
- registry1.dso.mil/ironbank/redhat/ubi/ubi9-minimal updated from 8.6 to 8.7

## [1.0.1-bb.7] - 2022-10-25

### Changed

- Changed `require-non-root-user` to support container exclusions

## [1.0.1-bb.6] - 2022-10-18

### Changed

- ironbank/opensource/kubernetes/kubectl updated from v1.24.4 to v1.25.3

## [1.0.1-bb.5] - 2022-09-14

### Changed

- Changed `disallow-nodeport-services` to `audit`
- Updated Gluon to `0.3.0`
- Fixed `disallow-pod-exec` from `attach` to `audit`

## [1.0.1-bb.4] - 2022-09-08

### Changed

- Updated `ttlSecondsAfterFinished` time to extend lifecycle

## [1.0.1-bb.3] - 2022-08-31

### Changed

- Added support for policy container exclusion

## [1.0.1-bb-2] - 2022-08-30

### Changed

- updated kubectl from `v.1.22.2` to `v1.24.4`

## [1.0.1-bb-1] - 2022-08-17

### Changed

- Fixed issue with `disallow-deprecated-apis` failing to install when checking old API versions

## [1.0.1-bb-0] - 2022-07-05

### Changed

- Updated policy preconditions to check for operation of create or update only

## [1.0.0-bb.13] - 2022-06-21

### Changed

- Enabled `disallow-nodeport-services` policy in enforcing mode

## [1.0.0-bb.12] - 2022-05-31

### Changed

- Separate host path policies from volume and hostpath

## [1.0.0-bb.11] - 2022-06-01

### Changed

- redhat ubi minimal from 8.5 to 8.6

## [1.0.0-bb.10] - 2022-05-24

### Changed

- Added policy to catch Persistent Volumes of type Hostpath
- Modified `restrict--host-path-mount.yaml`

## [1.0.0-bb.9] - 2022-05-13

### Changed

- Removed audit clusterpolicies
- disabled `disallow-istio-injection-bypass`
- disabled `require-drop-all-capabilities`
- disabled `require-istio-on-namespaces`
- disabled `restrict-capabilities`

## [1.0.0-bb.8] - 2022-03-29

### Changed

- Removed 1.22 deprecated API versions from test to support pipeline update to 1.23

## [1.0.0-bb.7] - 2022-03-03

### Changed

- Renamed `disallow-default-namespace` to `disallow-namespaces`. Parameterized list of disallowed namespaces, with `default` as the default.
- Decoupled testing from namespace
- Used default namespace for testing
- Updated test script to set policy action automatically

## [1.0.0-bb.6] - 2022-03-02

### Changed

- Added `localhost/*` as another acceptable default AppArmor profile
- Updated metadata in `Chart.yaml`
- Fixed typo for `restrict-capabilities` action in `values.yaml`
- Fixed `disallow-default-namespace` to allow blank namespace in pod controller template, but require pod controller to have a namespace.
- Fixed `restrict-host-path` to ignore pods with no volumes
- Fixed `require-non-root-group` exclusions indentions
- Fixed `disallow-deprecated-apis` matching to work with exclusions
- Updated `disallow-deprecated-apis` with Kubernetes 1.26 deprecations
- Updated `require-requests-equal-limits` to work with Kyverno 1.6.0
- Add `system:service-account-issuer-discovery` to the exclusion list for `disallow-rbac-on-default-serviceaccounts`. Clusters allow service accounts access to discovery.
- Fixed `disallow-rbac-on-default-serviceaccounts` to ignore role bindings without a subject.
- Fixed `require-non-root-user` to allow either `runAsNonRoot: true` or `runAsUser: >0`.
- Fixed `disallow-tolerations` to check pod controllers
- Renamed `require-ro-host-path` to `restrict-host-path-write` and added an `allow` list for paths
- Renamed `restrict-host-path` to `restrict-host-path-mount` to distinguish from `restrict-host-path-write`
- Increased memory allocation for `wait-for-ready` job to avoid OOM errors
- Renamed `disallow-subpath-volumes` to `disallow-shared-subpath-volume-writes` to clarify functionality.
- Fixed `disallow-shared-subpath-volume-writes` to narrow conditions specific to vulnerability
- Fixed `helpers.tpl` match and exclusion to handle `any` and `all` permutations

### Added

- `wait.sh` added to pipeline to wait for all policies to be ready before running helm test

### Removed

- `disallow-host-path` policy overlapped `restrict-volume-types` policy and was removed

## [1.0.0-bb.5] - 2022-02-03

### Changed

- Updated kubectl to 1.22
- Removed version from UBI image in most test resources (latest is ok)

## [1.0.0-bb.4] - 2022-01-31

### Changed

- Updated policy names and parameters to be inline with `docs/naming.md`
- Split restrict-selinux policy into restrict-selinux-type and disallow-selinux-options policies

## [1.0.0-bb.3] - 2022-01-28

### Added

- update-image-pull-policy policy
- disallow-subpath-volumes policy
- update-token-automount policy
- require-annotations policy
- require-image-signature
- require-istio-on-namespaces policy
- disallow-istio-injection-bypass policy
- require-labels policy
- disallow-annotations policy
- disallow-labels policy
- disallow-pod-exec policy
- disallow-tolerations policy
- max. on cpu and memory limits in require-cpu-limits and require-memory-limits policies
- Gatekeeper policy vs. Kyverno policy documentation
- Policy description documentation

### Changed

- require-resource-limits split into require-cpu-limits and require-memory-limits policies
- Added timestamp to wait-for-ready job so upgrades do not try to change immutable job.

### Removed

- cve-add-log4j2-mitigation policy (Mitigation proved to be insufficient)

## [1.0.0-bb.2] - 2022-01-14

### Added

- restrict-external-names policy
- disallow-host-path policy
- disallow-nodeport-services policy
- disallow-rbac-on-default-serviceaccounts policy
- require-drop-all-capabilities policy
- require-labels policy
- require-probes policy
- require-requests-equal-limits policy
- require-resource-limits policy
- require-ro-host-path policy
- restrict-host-path policy

### Changed

- Simplified restrict-capabilities policy
- Updated disallow-selinux to restrict-selinux-type in accordance with Pod Security Standards

## [1.0.0-bb.1] - 2021-12-20

### Added

- restrict-external-ips policy
- disallow-host-namespace policy
- disallow-default-namespace policy
- disallow-privilege-escalation policy
- disallow-privileged-containers policy
- disallow-selinux policy
- require-non-root-group policy
- require-non-root-user policy
- require-ro-rootfs policy
- restrict-apparmor policy
- restrict-group-id policy
- restrict-host-ports policy
- restrict-image-registries policy
- disallow-image-tags policy
- restrict-proc-mount policy
- restrict-seccomp policy
- restrict-sysctls policy
- restrict-user-id policy
- restrict-volume-types policy

## [1.0.0-bb.0] - 2021-12-2

### Added

- Initial creation of the chart
