
{{- define "kyverno.admission-controller.name" -}}
{{ template "kyverno.name" . }}-admission-controller
{{- end -}}

{{- define "kyverno.admission-controller.labels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.labels.common" .)
  (include "kyverno.admission-controller.matchLabels" .)
) -}}
{{- end -}}

{{- define "kyverno.admission-controller.matchLabels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.matchLabels.common" .)
  (include "kyverno.labels.component" "admission-controller")
) -}}
{{- end -}}

{{- define "kyverno.admission-controller.roleName" -}}
{{ include "kyverno.fullname" . }}:admission-controller
{{- end -}}

{{- define "kyverno.admission-controller.serviceAccountName" -}}
{{- if .Values.admissionController.rbac.create -}}
    {{ default (include "kyverno.admission-controller.name" .) .Values.admissionController.rbac.serviceAccount.name }}
{{- else -}}
    {{ required "A service account name is required when `rbac.create` is set to `false`" .Values.admissionController.rbac.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "kyverno.admission-controller.serviceName" -}}
{{- printf "%s-svc" (include "kyverno.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kyverno.admission-controller.caCertificatesConfigMapName" -}}
{{ printf "%s-ca-certificates" (include "kyverno.admission-controller.name" .) }}
{{- end -}}

{{- define "kyverno.background-controller.name" -}}
{{ template "kyverno.name" . }}-background-controller
{{- end -}}

{{- define "kyverno.background-controller.labels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.labels.common" .)
  (include "kyverno.background-controller.matchLabels" .)
) -}}
{{- end -}}

{{- define "kyverno.background-controller.matchLabels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.matchLabels.common" .)
  (include "kyverno.labels.component" "background-controller")
) -}}
{{- end -}}

{{- define "kyverno.background-controller.image" -}}
{{- $imageRegistry := default .image.registry .globalRegistry -}}
{{- if $imageRegistry -}}
  {{ $imageRegistry }}/{{ required "An image repository is required" .image.repository }}:{{ default .defaultTag .image.tag }}
{{- else -}}
  {{ required "An image repository is required" .image.repository }}:{{ default .defaultTag .image.tag }}
{{- end -}}
{{- end -}}

{{- define "kyverno.background-controller.roleName" -}}
{{ include "kyverno.fullname" . }}:background-controller
{{- end -}}

{{- define "kyverno.background-controller.serviceAccountName" -}}
{{- if .Values.backgroundController.rbac.create -}}
    {{ default (include "kyverno.background-controller.name" .) .Values.backgroundController.rbac.serviceAccount.name }}
{{- else -}}
    {{ required "A service account name is required when `rbac.create` is set to `false`" .Values.backgroundController.rbac.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "kyverno.background-controller.caCertificatesConfigMapName" -}}
{{ printf "%s-ca-certificates" (include "kyverno.background-controller.name" .) }}
{{- end -}}

{{- define "kyverno.cleanup.labels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.labels.common" .)
  (include "kyverno.matchLabels.common" .)
  (include "kyverno.labels.component" "cleanup")
) -}}
{{- end -}}

{{- define "kyverno.cleanup-controller.name" -}}
{{ template "kyverno.name" . }}-cleanup-controller
{{- end -}}

{{- define "kyverno.cleanup-controller.labels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.labels.common" .)
  (include "kyverno.cleanup-controller.matchLabels" .)
) -}}
{{- end -}}

{{- define "kyverno.cleanup-controller.matchLabels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.matchLabels.common" .)
  (include "kyverno.labels.component" "cleanup-controller")
) -}}
{{- end -}}

{{- define "kyverno.cleanup-controller.image" -}}
{{- $imageRegistry := default .image.registry .globalRegistry -}}
{{- if $imageRegistry -}}
  {{ $imageRegistry }}/{{ required "An image repository is required" .image.repository }}:{{ default .defaultTag .image.tag }}
{{- else -}}
  {{ required "An image repository is required" .image.repository }}:{{ default .defaultTag .image.tag }}
{{- end -}}
{{- end -}}

{{- define "kyverno.cleanup-controller.roleName" -}}
{{ include "kyverno.fullname" . }}:cleanup-controller
{{- end -}}

{{- define "kyverno.cleanup-controller.serviceAccountName" -}}
{{- if .Values.cleanupController.rbac.create -}}
    {{ default (include "kyverno.cleanup-controller.name" .) .Values.cleanupController.rbac.serviceAccount.name }}
{{- else -}}
    {{ required "A service account name is required when `rbac.create` is set to `false`" .Values.cleanupController.rbac.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "kyverno.reports-controller.name" -}}
{{ template "kyverno.name" . }}-reports-controller
{{- end -}}