{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prometheus-operator-addons.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prometheus-operator-addons.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "prometheus-operator-addons.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate ingress rules
*/}}
{{- define "prometheus-operator-addons.ingress.rules" -}}
{{- $g := . -}}
{{- range $i, $v := .Values.ingress.services }}
  - host: {{ $v.name }}{{ $g.Values.servicesuffix }}.{{ $g.Values.environment }}.{{ $g.Values.domain }}
    http:
      paths:
      - path: /*
        backend:
          serviceName: {{ $v.backend.service }}
          servicePort: {{ $v.backend.port }}
{{- if $v.altPaths }}
{{ toYaml $v.altPaths | indent 6 }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate ingress tls config
*/}}
{{- define "prometheus-operator-addons.ingress.tls" -}}
{{- $g := . -}}
{{- range $i, $v := $g.Values.ingress.services }}
    - {{ $v.name }}{{ $g.Values.servicesuffix }}.{{ $g.Values.environment }}.{{ $g.Values.domain }}
{{- end }}
{{- end }}
