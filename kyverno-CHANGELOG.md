# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

---

## [3.2.7-bb.0] - 2024-10-01

### Changed

- Updated `kyverno` chart from `3.2.6` to `3.2.7` and app version from `v1.12.5` to `v1.12.6`
- Updated `kubectl` from `1.29.7` to `1.30.5`
- Updated `kyverno`, `background-controller`, `cleanup-controller`, `reports-controller`, `kyvernocli`, `kyvernopre` from `v1.12.5` to `v1.12.6`

## [3.2.6-bb.3] - 2024-09-30

### Changed

- Updated secrets.sh with kubectl wait for namespace and secret creation

## [3.2.6-bb.2] - 2024-09-20

### Changed

- Updated secrets.sh with --wait=false on kubectl delete namespace

## [3.2.6-bb.1] - 2024-09-20

### Changed

- Updated secrets.sh and clusterpolicy.sh to fix early exit.

## [3.2.6-bb.0] - 2024-07-30

### Changed

- Updated kyverno chart from `3.2.5` to `3.2.6` and app version from `v1.12.5` to `v1.12.5`
- Updated `kubectl` from `1.29.6` to `1.29.7`
- Updated `kyverno`, `background-controller`, `cleanup-controller`, `reports-controller`, `kyvernopre`  from `v1.12.4` to `v1.12.5`
- Added reference to `kyvernocli` with version `v1.12.5`

## [3.2.5-bb.5] - 2024-07-30

### Changed

- Update secret sync test script to check for kyverno-bbtest-secret already existing.

## [3.2.5-bb.4] - 2024-07-30

### Changed

- Update secret sync test script to check for secret sync policy before creating namespace.
- Update gluon to latest v0.5.2

## [3.2.5-bb.3] - 2024-07-18

### Changed

- Updated `kubectl` from `1.29.4` to `1.29.6`
- Updated `kyverno`, `background-controller`, `cleanup-controller`, `reports-controller`, `kyvernopre`  from `v1.12.3` to `v1.12.4`
- Added reference to `kyvernocli` with version `v1.12.4`
- Updated DEVELOPMENT_MAINTENANCE.md to accurately reflect list of files with `automountServiceAccountToken` changes.

## [3.2.5-bb.2] - 2024-07-18

### Removed

- Removed duplicate dashboard.json in `chart/charts/grafana/`

## [3.2.5-bb.1] - 2024-07-15

### Changed

- Disabled policy cleanup in post-upgarde hook in `/chart/values.yaml`

## [3.2.5-bb.0] - 2024-07-09

### Changed

- Updated upstream chart from `3.2.4` to `3.2.5` and app version from `v1.12.3` to `v1.12.4`

## [3.2.4-bb.2] - 2024-06-18

### Changed

- Updated DEVELOPMENT_MAINTENANCE.md with instructions for integration testing in pipeline

## [3.2.4-bb.1] - 2024-06-13

### Changed

- Revert Oscal package validation checks

## [3.2.4-bb.0] - 2024-06-05

### Changed

- Updated upstream chart from `3.1.4` to `3.2.4`
- Updated `kyverno`, `background-controller`, `cleanup-controller`, `reports-controller`, `kyvernopre`  from `v1.11.4` to `v1.12.3`
- Updated `kubectl` from `1.29.3` to `1.29.4`
- Added reference to kyvernocli with version `1.12.3`

## [3.1.4-bb.9] - 2024-05-24

### Changed

- Added healthcheck validation and configuration validation

## [3.1.4-bb.8] - 2024-04-29

### Changed

- Updated CHANGELOG to fix formatting

## [3.1.4-bb.7] - 2024-04-23

### Changed

- Fixed README.md for the chart that was overwritten and the README.md.gotmpl

## [3.1.4-bb.6] - 2024-04-16

### Changed

- Updated `kubectl` from `1.28.7` to `1.29.3`

## [3.1.4-bb.5] - 2024-04-05

### Added

- Custom network policies

## [3.1.4-bb.4] - 2024-03-11

### Changed

- Added Openshift updates for deploying kyverno into Openshift cluster

## [3.1.4-bb.3] - 2024-03-08

### Changed

- Updated `kubectl` from `1.28.6` to `1.28.7`

## [3.1.4-bb.2] - 2024-02-16

### Changed

- Added the resource limits for pre-delete and post-upgrade pods.

## [3.1.4-bb.1] - 2024-01-26

### Changed

- Updated `kubectl` from `1.28.5` to `1.28.6`

## [3.1.4-bb.0] - 2024-01-22

### Changed

- Updated upstream chart from `3.1.3` to `3.1.4`
- Updated `kyverno`, `background-controller`, `cleanup-controller`, `reports-controller`, `kyvernopre`  from `v1.11.3` to `v1.11.4`
- Updated `kubectl` from `1.28.4` to `1.28.5`

## [3.1.3-bb.0] - 2024-01-10

### Changed

- Updated upstream chart from `3.1.1` to `3.1.3`
- Updated `kyverno`, `background-controller`, `cleanup-controller`, `reports-controller`, `kyvernopre`  from `v1.11.1` to `v1.11.3`
- Updated `kubectl` from `1.28.4` to `1.28.5`

## [3.1.1-bb.0] - 2024-01-8

### Changed

- Updated upstream chart from `3.1.0` to `3.1.1`
- Updated `kyverno`, `background-controller`, `cleanup-controller`, `reports-controller`, `kyvernopre`  from `v1.11.0` to `v1.11.1`
- Updated `gluon` from `0.3.1` to `0.4.6`
- Added `ServiceMonitor` CRD

## [3.1.0-bb.2] - 2023-12-14

### Changed

- Updated `ubi8-minimal:8.9` to `ubi9-minimal:9.3`

## [3.1.0-bb.1] - 2023-12-06

### Changed

- Updating OSCAL Component File.

## [3.1.0-bb.0] - 2023-11-21

### Changed

- Updated `kubectl` from `v1.28.3` to `v1.28.4`
- Updated `kyverno` from `v1.10.3` to `v1.11.0`
- Updated `background-controller` from `1.10.3` to `v1.11.0`
- Updated `cleanup-controller` from `v1.10.3` to `v1.11.0`
- Updated `reports-controller` from `1.10.3` to `v1.11.0`
- Updated `kyvernopre` from `v1.10.3` to `v1.11.0`
- Updated `ubi8-minimal` from `8.8` to `8.9`

## [3.0.0-bb.13] - 2023-11-24

### Changed

- Allow the automountserviceaccounttoken to be disabled/enabled

## [3.0.0-bb.12] - 2023-11-16

### Changed

- Added `registry1.dso.mil/ironbank/redhat/ubi/ubi8-minimal:8.8` to `tests/images.txt`

## [3.0.0-bb.11] - 2023-11-06

### Changed

- Added the rights to get, list, watch, update, and patch the kyverno-background-controller serviceaccount

## [3.0.0-bb.10] - 2023-11-02

### Changed

- registry1.dso.mil/ironbank/opensource/kubernetes/kubectl patch v1.28.2 -> v1.28.3
- Added `.Values.allowExternalRegistryEgress` option to enable a `NetworkPolicy` that allows the Admission Controller to talk to external networks. Default: false

## [3.0.0-bb.9] - 2023-10-24

### Changed

- Add pod level securityContext for kyverno test

## [3.0.0-bb.8] - 2023-10-18

### Changed

- Fixed RunAsGroup typo in chart/values.yaml

## [3.0.0-bb.7] - 2023-10-17

### Changed

- Modified OSCAL Version for kyverno and updated to 1.1.1

## [3.0.0-bb.6] - 2023-10-13

### Changed

- Update `kubectl version` to v1.28.2

## [3.0.0-bb.5] - 2023-10-11

### Changed

- Modified `features.policyExceptions.enabled` to true
- Restricted new `policyExceptions` to the kyerno `namespace`

## [3.0.0-bb.4] - 2023-09-20

### Changed

- Modified runAsGroup securityContext for kyverno containers

## [3.0.0-bb.3] - 2023-09-19

### Changed

- Set controlPlaneCidr to 0.0.0.0/0 for package test

## [3.0.0-bb.2] - 2023-09-14

### Changed

- Made test resources conditional on bbtests.enabled

## [3.0.0-bb.2] - 2023-09-14

### Changed

- Made test resources conditional on bbtests.enabled

## [3.0.0-bb.1] - 2023-09-12

### Changed

- NetworkPolicy fixes based on new labels

## [3.0.0-bb.0] - 2023-08-24

### Changed

- Updated to latest images 1.10.3
- Updated to latest chart 3.0.0

## [2.7.2-bb.0] - 2023-04-17

### Changed

- Updated to latest image 1.9.2
- Updated to latest chart 2.7.2

## [2.6.5-bb.3] - 2023-03-13

### Changed

- Updated kubectl to v1.26.2

## [2.6.5-bb.2] - 2023-02-07

### Changed

- Updated kubectl to v1.26.1

## [2.6.5-bb.1] - 2023-01-26

### Changed

- Updated kubectl to v1.25.6

## [2.6.5-bb.0] - 2023-01-06

### Changed

- Updated kubectl to v1.25.5
- Updated Helm chart to v2.6.5
- Updated appVersion to v1.8.5

## [2.6.1-bb.0] - 2022-11-15

### Changed

- Updated Helm chart to v2.6.1
- Updated Kyverno image to v1.8.1
- Updated kubectl image to v1.25.4
- Updated ubi image to 8.7

## [2.6.0-bb.2] - 2022-10-5-28

### Added

- Added pull policy arg to kyverno deployment and network policy for container registries

## [2.6.0-bb.1] - 2022-11-01

### Changed

- Updated Kubectl image to 1.25.3

## [2.6.0-bb.0] - 2022-10-19

### Changed

- Updated Helm chart to v2.6.0
- Updated Kyverno to v1.8.0

## [2.5.4-bb.0] - 2022-10-06

### Changed

- Updated Helm chart to v2.5.4
- Updated Kyverno to v1.7.4

## [2.5.3-bb.1] - 2022-09-28

### Changed

- Updated kubectl to v1.25.2
- Update gluon to 0.3.1

## [2.5.3-bb.0] - 2022-08-30

### Changed

- Updated Helm chart to v2.5.3
- Updated Kyverno to v1.7.3
- updated kubectl from v1.22.2 to v1.24.4

## [2.5.2-bb.0] - 2022-08-12

### Changed

- Updated Helm chart to v2.5.2
- Updated Kyverno to v1.7.2

## [2.2.0-bb.5] - 2022-04-11

### Added

- OSCAL documentation with initial 800-53b controls satisfied

## [2.2.0-bb.4] - 2022-03-22

### Changed

- Added kyverno introduction
- Updated overview with instructions to migrate from gatekeeper

## [2.2.0-bb.3] - 2021-03-08

### Changed

- Increase default QPS and burst rates to eliminate client throttling

## [2.2.0-bb.2] - 2021-02-17

### Changed

- Fixed datasource for Grafana dashboard

## [2.2.0-bb.1] - 2021-02-14

### Changed

- Added tag to kubectl image for test

## [2.2.0-bb.0] - 2021-02-09

### Changed

- Bumped chart to v2.2.0, which contains Kyverno version 1.6.0

## [2.1.10-bb.0] - 2021-01-28

### Changed

- Bumped chart to Kyverno version 1.5.8

## [2.1.7-bb.2] - 2021-01-27

### Changed

- Update Chart.yaml to follow new standardization for release automation

## [2.1.7-bb.1] - 2021-01-27

### Changed

- Bumped chart to Kyverno version 1.5.7
- Fix deployment for Helm release name overrides causing kyverno-pre to fail
- Updated test library (gluon) to 0.2.5

## [2.1.7-bb.0] - 2021-01-21

### Changed

- Bumped chart to Kyverno version 1.5.5
- Increased CPU to 0.5 default for main pod to handle larger number of policies

## [2.1.3-bb.3] - 2021-12-15

### Changed

- Updated Memory and CPU resources for kyverno in values.yaml

## [2.1.3-bb.2] - 2021-12-14

### Changed

- Adjusted Helm test to use curl so Iron Bank base image could be used
- Moved Helm test configuration (`bbtest`) to values.yaml

## [2.1.3-bb.1] - 2021-12-14

### Changed

- Added namespaces to test resources
- Updated dashboard to fix JSON syntax

## [2.1.3-bb.0] - 2021-12-07

### Added

- Grafana dashboard
- Overview document

### Changed

- Updated Helm chart to 2.1.3 from upstream
- Replaced `PodMonitor` with `ServiceMonitor`
- Updated test resources to latest images (gluon, kubectl)
- Split test resources into one resource per file
- Updated labels and annotations on test resources to fix upgrade issue
- Added timeout to scripted Helm test

## [2.0.3-bb.0] - 2021-10-18

### Added

- Initial creation of the chart
