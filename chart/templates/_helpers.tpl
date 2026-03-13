{{/* vim: set filetype=mustache: */}}
{{/* Expand the name of the chart. */}}
{{- define "kyverno-policies.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kyverno.fullname" -}}
{{- if .Values.fullnameOverride -}}
  {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- $name := default .Chart.Name .Values.nameOverride -}}
  {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "kyverno-policies.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Helm required labels */}}
{{- define "kyverno-policies.labels" -}}
app.kubernetes.io/name: {{ template "kyverno-policies.name" . }}
helm.sh/chart: {{ template "kyverno-policies.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: "{{ .Chart.Version }}"
app.kubernetes.io/component: policy
app.kubernetes.io/part-of: kyverno
app: kyverno
{{- if .Values.customLabels }}
{{ toYaml .Values.customLabels }}
{{- end }}
{{- end -}}

{{/* Helm required labels */}}
{{- define "kyverno-policies.test-labels" -}}
app.kubernetes.io/name: {{ template "kyverno-policies.name" . }}-test
helm.sh/chart: {{ template "kyverno-policies.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: "{{ .Chart.Version }}"
app.kubernetes.io/component: policy
app.kubernetes.io/part-of: kyverno
{{- end -}}

{{/* WebhookTimeoutSeconds key/value.  Expects name of policy in .name */}}
{{- define "kyverno-policies.webhookTimeoutSeconds" -}}
{{- $webhookTimeoutSeconds := default .Values.webhookTimeoutSeconds (dig .name "webhookTimeoutSeconds" nil .Values.policies) -}}
{{- if $webhookTimeoutSeconds }}
webhookTimeoutSeconds: {{ $webhookTimeoutSeconds }}
{{- end }}
{{- end -}}

{{/* excludeContainers values.  Expects name of policy in .name */}}
{{- define "kyverno-policies.excludeContainers" -}}
  {{- $globalexcludeContainers := .Values.excludeContainers -}}
  {{- $validateOnly := (dig "validateOnly" nil .) -}}
  {{- $excludeContainers := (dig .name "parameters" "excludeContainers" nil .Values.policies) -}}
    foreach:
    {{- if not $validateOnly }}
    - list: request.object.spec.[ephemeralContainers, initContainers, containers][]
    {{- else }}
    - list: request.object.spec.[{{$validateOnly}}][]
    {{- end }}
    {{- if or $globalexcludeContainers $excludeContainers }}
      preconditions:
        all:
        {{- include "kyverno-policies.excludeContainersPrecondition" (merge (dict "name" .name "operator" "AnyNotIn") .) | nindent 4 }}
    {{- end }}
{{- end -}}

{{/* excludeContainers values.  Expects name of policy in .name */}}
{{- define "kyverno-policies.excludeContainersPrecondition" -}}
  {{- $globalexcludeContainers := .Values.excludeContainers -}}
  {{- $excludeContainers := (dig .name "parameters" "excludeContainers" nil .Values.policies) -}}
    {{- if or $globalexcludeContainers $excludeContainers }}
      - key: "{{ "{{" }} element.name {{ "}}" }}"
        operator: {{ .operator }}
        value:
          {{- if $globalexcludeContainers }}
            {{- toYaml $globalexcludeContainers | nindent 10 -}}
          {{- end }}
          {{- if $excludeContainers }}
            {{- toYaml $excludeContainers | nindent 10 -}}
          {{- end }}
    {{- end }}
{{- end -}}

{{/* Match key/value.  Expects name of policy in .name and default kind in .kind as a list */}}
{{- define "kyverno-policies.match" -}}
  {{- $policyMatch := (dig .name "match" nil .Values.policies) -}}
  {{- if not (kindIs "map" $policyMatch) -}}
    {{- $policyMatch = (dict "any" $policyMatch) -}}
  {{- end -}}
match:
  all:
  - resources:
      kinds:
      {{- toYaml .kinds | nindent 6 -}}
  {{- if $policyMatch }}
    {{- if $policyMatch.all }}
      {{- toYaml $policyMatch.all | nindent 2 }}
    {{- end }}
    {{- if $policyMatch.any }}
  any:
      {{- toYaml $policyMatch.any | nindent 2 }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/* Exclude key/value.  Expects name of policy in .name */}}
{{- define "kyverno-policies.exclude" -}}
  {{- $globalExclude := .Values.exclude -}}
  {{- if not (kindIs "map" $globalExclude) -}}
    {{- $globalExclude = (dict "any" $globalExclude) -}}
  {{- end -}}
  {{- $policyExclude := (dig .name "exclude" nil .Values.policies) -}}
  {{- if not (kindIs "map" $policyExclude) -}}
    {{- $policyExclude := (dict "any" $policyExclude) -}}
  {{- end -}}
  {{- if or $globalExclude $policyExclude }}
exclude:
    {{- if or $globalExclude.all $policyExclude.all }}
  all:
      {{- if $globalExclude.all }}
        {{- toYaml $globalExclude.all | nindent 2 }}
      {{- end }}
      {{- if $policyExclude.all }}
        {{- toYaml $policyExclude.all | nindent 2 }}
      {{- end }}
    {{- end }}
    {{- if or $globalExclude.any $policyExclude.any }}
  any:
      {{- if $globalExclude.any }}
        {{- toYaml $globalExclude.any | nindent 2 }}
      {{- end }}
      {{- if $policyExclude.any }}
        {{- toYaml $policyExclude.any | nindent 2 }}
      {{- end }}
    {{- end }}
  {{- end -}}
{{- end -}}

{{/* Add context for configMap to rule.  Expects name of policy in .name */}}
{{- define "kyverno-policies.context" -}}
{{- if (dig .name "parameters" nil .Values.policies) }}
context:
- name: configmap
  configMap:
    name: {{ .name }}
    namespace: {{ .Release.Namespace }}
{{- end }}
{{- end -}}

{{/* Add configmap using exclude key/value.  Expects name of policy in .name */}}
{{- define "kyverno-policies.configmap" -}}
{{- if (dig .name "parameters" nil .Values.policies) }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .name }}
  namespace: {{ .Release.Namespace }}
  labels: {{- include "kyverno-policies.labels" . | nindent 4 }}
data:
  {{- range $k, $v := (dig .name "parameters" nil .Values.policies) }}
    {{- $k | nindent 2 }}:
    {{- if (kindIs "slice" $v) }}
      {{- join " | " $v | quote | indent 1 }}
    {{- else }}
      {{- toYaml $v | indent 1 }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end -}}

{{/* Add default precondition */}}
{{- define "kyverno-policies.precondition.default" -}}
preconditions:
  all:
  {{- include "kyverno-policies.precondition.create-update-background" . | nindent 2 }}
{{- end -}}

{{/* Add a precondition that triggers on create or update events only */}}
{{- define "kyverno-policies.precondition.create-update-background" -}}
- key: "{{ "{{" }}request.operation || 'BACKGROUND'{{ "}}" }}"
  operator: In
  value:
  - CREATE
  - UPDATE
  - BACKGROUND
{{- end -}}

{{/* Get deployed Kyverno version from Kubernetes */}}
{{- define "kyverno-policies.kyvernoVersion" -}}
{{- $version := "" -}}
{{- if eq .Values.kyvernoVersion "autodetect" }}
{{- with (lookup "apps/v1" "Deployment" .Release.Namespace "kyverno") -}}
  {{- with (first .spec.template.spec.containers) -}}
    {{- $imageTag := (last (splitList ":" .image)) -}}
    {{- $version = trimPrefix "v" $imageTag -}}
  {{- end -}}
{{- end -}}
{{ $version }}
{{- else -}}
{{ .Values.kyvernoVersion }}
{{- end -}}
{{- end -}}

{{/* Fail if deployed Kyverno does not match */}}
{{- define "kyverno-policies.supportedKyvernoCheck" -}}
{{- $supportedKyverno := index . "ver" -}}
{{- $top := index . "top" }}
{{- if (include "kyverno-policies.kyvernoVersion" $top) -}}
  {{- if not ( semverCompare $supportedKyverno (include "kyverno-policies.kyvernoVersion" $top) ) -}}
    {{- fail (printf "Kyverno version is too low, expected %s" $supportedKyverno) -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/* Set failurePolicy to ignore when validationFailureAction is audit or warn (see issue #9) */}}
{{- define "setFailurePolicy" }}
{{- if or (eq "audit" (lower . )) (eq "warn" (lower . )) }}
{{- print "Ignore" -}}
{{- end -}}
{{- end -}}

{{/* ---- BB VPol helpers (celPoliciesBeta) ---- */}}

{{/* Based on upstream kyverno-policies.policyValidationActions + kyverno-policies.validationActions
     https://github.com/kyverno/kyverno/blob/main/charts/kyverno-policies/templates/_helpers.tpl#L113-L129
     Changes: (1) adds Warn→Warn mapping (upstream only handles Enforce→Deny, else→Audit),
     (2) reads from celPoliciesBeta per-policy override instead of validationFailureActionByPolicy.
     Precedence: celPoliciesBeta.<name>.validationFailureAction → Values.validationFailureAction → default Audit. */}}
{{- define "bb-kyverno-policies.validationActions" -}}
{{- $name := .name -}}
{{- $action := default .Values.validationFailureAction (dig $name "validationFailureAction" "" .Values.celPoliciesBeta) -}}
{{- if eq $action "Enforce" }}
validationActions:
  - Deny
{{- else if eq $action "Warn" }}
validationActions:
  - Warn
{{- else }}
validationActions:
  - Audit
{{- end }}
{{- end -}}

{{/* No upstream helper — upstream uses bare .Values.failurePolicy in VPol templates.
     https://github.com/kyverno/kyverno/blob/main/charts/kyverno-policies/templates/baseline/disallow-privileged-containers.cel.yaml#L22
     Changes: adds auto-derive via existing setFailurePolicy (Audit/Warn→Ignore), plus per-policy
     and celPoliciesBeta global override layers.
     Precedence: per-policy → celPoliciesBeta global → auto-derive from action → Values.failurePolicy. */}}
{{- define "bb-kyverno-policies.vpol-failurePolicy" -}}
{{- $name := .name -}}
{{- $action := default .Values.validationFailureAction (dig $name "validationFailureAction" "" .Values.celPoliciesBeta) -}}
{{- $perPolicy := dig $name "failurePolicy" "" .Values.celPoliciesBeta -}}
{{- $globalBeta := default "" .Values.celPoliciesBeta.failurePolicy -}}
{{- $auto := include "setFailurePolicy" $action -}}
{{- $computed := default .Values.failurePolicy $auto -}}
{{- default (default $computed $globalBeta) $perPolicy -}}
{{- end -}}

{{/* No upstream helper — upstream VPol template omits background entirely (defaults to Kyverno's
     server-side default). CPol template uses bare .Values.background.
     https://github.com/kyverno/kyverno/blob/main/charts/kyverno-policies/templates/baseline/disallow-privileged-containers.cel.yaml
     Changes: wires to VPol's evaluation.background.enabled with per-policy and celPoliciesBeta
     global overrides. Uses toString to distinguish false (explicit) from "" (not set).
     Precedence: per-policy → celPoliciesBeta global → Values.background. */}}
{{- define "bb-kyverno-policies.vpol-background" -}}
{{- $name := .name -}}
{{- $perPolicy := dig $name "background" "" .Values.celPoliciesBeta -}}
{{- $globalBeta := .Values.celPoliciesBeta.background -}}
{{- if ne ($perPolicy | toString) "" -}}
  {{- $perPolicy -}}
{{- else if ne ($globalBeta | toString) "" -}}
  {{- $globalBeta -}}
{{- else -}}
  {{- .Values.background -}}
{{- end -}}
{{- end -}}

{{/* No upstream equivalent — upstream VPol templates do not set webhookConfiguration.timeoutSeconds.
     BB CPol uses the kyverno-policies.webhookTimeoutSeconds helper for the same purpose.
     Changes: new helper for VPol's spec.webhookConfiguration.timeoutSeconds with per-policy and
     celPoliciesBeta global overrides.
     Precedence: per-policy → celPoliciesBeta global → Values.webhookTimeoutSeconds. */}}
{{- define "bb-kyverno-policies.vpol-webhookTimeoutSeconds" -}}
{{- $name := .name -}}
{{- $perPolicy := dig $name "webhookTimeoutSeconds" "" .Values.celPoliciesBeta -}}
{{- $globalBeta := default "" .Values.celPoliciesBeta.webhookTimeoutSeconds -}}
{{- $val := default (default .Values.webhookTimeoutSeconds $globalBeta) $perPolicy -}}
{{- if $val }}
webhookConfiguration:
  timeoutSeconds: {{ $val }}
{{- end }}
{{- end -}}

{{/* No upstream equivalent — upstream CPol uses the pod-policies.kyverno.io/autogen-controllers
     annotation; upstream VPol templates omit autogen entirely (Kyverno defaults to all controllers).
     Changes: new helper that converts the CamelCase CSV format used by .Values.autogenControllers
     to VPol's spec.autogen.podControllers.controllers list (lowercase plural per Kyverno source
     pkg/cel/autogen/data.go). Accepts same input format as CPol so users don't learn a new syntax.
     "none" suppresses the autogen block entirely.
     Precedence: per-policy → celPoliciesBeta global → Values.autogenControllers. */}}
{{- define "bb-kyverno-policies.vpol-autogenControllers" -}}
{{- $name := .name -}}
{{- $perPolicy := dig $name "autogenControllers" "" .Values.celPoliciesBeta -}}
{{- $globalBeta := default "" .Values.celPoliciesBeta.autogenControllers -}}
{{- $val := default (default .Values.autogenControllers $globalBeta) $perPolicy -}}
{{- if and $val (ne (lower $val) "none") }}
autogen:
  podControllers:
    controllers:
    {{- range (splitList "," $val) }}
    {{- $t := trim . }}
    {{- if eq $t "Deployment" }}
    - deployments
    {{- else if eq $t "ReplicaSet" }}
    - replicasets
    {{- else if eq $t "DaemonSet" }}
    - daemonsets
    {{- else if eq $t "StatefulSet" }}
    - statefulsets
    {{- else if eq $t "Job" }}
    - jobs
    {{- else if eq $t "CronJob" }}
    - cronjobs
    {{- end }}
    {{- end }}
{{- end }}
{{- end -}}

{{/* Namespace exclusion for VPol via matchConditions CEL.
     CPol equivalent: kyverno-policies.exclude helper (lines 116-147 of _helpers.tpl).

     The CPol exclude helper supports a rich structure (any/all blocks with resources.namespaces,
     resources.names, subjects, clusterRoles, roles). VPol matchConstraints has no equivalent
     structure — excludeResourceRules doesn't support namespace filtering.

     This helper covers the most common case: excluding namespaces by name. The CPol global
     default is exclude.any[].resources.namespaces: [kube-system], which maps directly to
     excludeNamespaces: [kube-system].

     NOT COVERED by this helper (use celPoliciesBeta.<name>.matchConditions instead):
     - exclude.all semantics (AND logic across multiple conditions)
     - exclude.any[].resources.names (resource name exclusions)
     - exclude.any[].subjects / clusterRoles / roles (user-based exclusions)
     Precedence: celPoliciesBeta.<name>.excludeNamespaces + celPoliciesBeta.excludeNamespaces (merged). */}}
{{- define "bb-kyverno-policies.vpol-excludeNamespaces" -}}
{{- $name := .name -}}
{{- $global := default (list) .Values.celPoliciesBeta.excludeNamespaces -}}
{{- $perPolicy := default (list) (dig $name "excludeNamespaces" nil .Values.celPoliciesBeta) -}}
{{- $merged := concat $global $perPolicy | uniq -}}
{{- if $merged }}
- name: exclude-namespaces
  expression: {{ printf "!(object.metadata.namespace in %s)" ($merged | toJson) | quote }}
{{- end }}
{{- end -}}

{{/* Build the allContainers CEL variable expression, with optional container name filtering.
     CPol equivalent: kyverno-policies.excludeContainers helper (lines 59-75 of _helpers.tpl).

     The CPol helper uses JMESPath foreach with preconditions (AnyNotIn on element.name) to
     skip named containers. VPol has no foreach or JMESPath — CEL .filter() on the container
     list achieves the same behavioral result: excluded containers are removed before validation.

     The CPol helper also supports a validateOnly parameter (e.g. "containers") that limits
     which container types are checked. This helper does not yet support validateOnly — it
     always checks all three container types. This is a future-policy concern since
     disallow-privileged-containers checks all container types in both CPol and VPol.

     Precedence: celPoliciesBeta.<name>.excludeContainers + celPoliciesBeta.excludeContainers (merged). */}}
{{- define "bb-kyverno-policies.vpol-allContainers" -}}
{{- $name := .name -}}
{{- $global := default (list) .Values.celPoliciesBeta.excludeContainers -}}
{{- $perPolicy := default (list) (dig $name "excludeContainers" nil .Values.celPoliciesBeta) -}}
{{- $merged := concat $global $perPolicy | uniq -}}
{{- $base := "object.spec.containers + object.spec.?initContainers.orValue([]) + object.spec.?ephemeralContainers.orValue([])" -}}
{{- if $merged -}}
  {{- printf "(%s).filter(c, !(c.name in %s))" $base ($merged | toJson) -}}
{{- else -}}
  {{- $base -}}
{{- end -}}
{{- end -}}