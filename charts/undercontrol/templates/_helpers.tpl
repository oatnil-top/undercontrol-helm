{{/*
Expand the name of the chart.
*/}}
{{- define "undercontrol.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "undercontrol.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart label
*/}}
{{- define "undercontrol.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "undercontrol.labels" -}}
helm.sh/chart: {{ include "undercontrol.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Backend labels
*/}}
{{- define "undercontrol.backend.labels" -}}
{{ include "undercontrol.labels" . }}
app.kubernetes.io/name: {{ include "undercontrol.name" . }}-backend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Backend selector labels
*/}}
{{- define "undercontrol.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "undercontrol.name" . }}-backend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Frontend labels
*/}}
{{- define "undercontrol.frontend.labels" -}}
{{ include "undercontrol.labels" . }}
app.kubernetes.io/name: {{ include "undercontrol.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
Frontend selector labels
*/}}
{{- define "undercontrol.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "undercontrol.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Backend fullname
*/}}
{{- define "undercontrol.backend.fullname" -}}
{{ include "undercontrol.fullname" . }}-backend
{{- end }}

{{/*
Frontend fullname
*/}}
{{- define "undercontrol.frontend.fullname" -}}
{{ include "undercontrol.fullname" . }}-frontend
{{- end }}

{{/*
Backend image
*/}}
{{- define "undercontrol.backend.image" -}}
{{- $tag := default .Chart.AppVersion .Values.backend.image.tag }}
{{- printf "%s:%s" .Values.backend.image.repository $tag }}
{{- end }}

{{/*
Frontend image
*/}}
{{- define "undercontrol.frontend.image" -}}
{{- $tag := default .Chart.AppVersion .Values.frontend.image.tag }}
{{- printf "%s:%s" .Values.frontend.image.repository $tag }}
{{- end }}

{{/*
Secret name for sensitive values
*/}}
{{- define "undercontrol.secretName" -}}
{{- if .Values.backend.existingSecret }}
{{- .Values.backend.existingSecret }}
{{- else }}
{{- include "undercontrol.fullname" . }}
{{- end }}
{{- end }}
