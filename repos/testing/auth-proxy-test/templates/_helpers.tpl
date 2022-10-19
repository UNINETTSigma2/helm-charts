{{/*
Expand the name of the chart.
*/}}
{{- define "auth-proxy-test.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "auth-proxy-test.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "auth-proxy-test.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "auth-proxy-test.labels" -}}
helm.sh/chart: {{ include "auth-proxy-test.chart" . }}
{{ include "auth-proxy-test.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "auth-proxy-test.selectorLabels" -}}
app.kubernetes.io/name: {{ include "auth-proxy-test.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
goidc-proxy config
*/}}
{{- define "oidcconfig" -}}
{
        "proxy": {
            "target": "http://localhost:8080/"
        },
        "engine": {
            "client_id": "{{ .Values.appstore_generated_data.aai.client_id }}",
            "client_secret": "{{ .Values.appstore_generated_data.aai.client_secret }}",
            "issuer_url": "{{ .Values.appstore_generated_data.aai.issuer_url }}",
            "redirect_url": "https://{{ .Values.ingress.host }}/oauth2/callback",
            "scopes": "{{- join "," .Values.appstore_generated_data.aai.scopes -}}",
            "signkey": "",
            "token_type": "",
            "jwt_token_isser": "",
            "groups_endpoint": "",
            "groups_claim": "principals",
            "username_claim": "sub",
            "authorized_principals": "{{- join "," .Values.appstore_generated_data.aai.authorized_principals -}}",
            "xhr_endpoints": "",
            "twofactor": {
                "all": false,
                "principals": "",
                "acr_values": "",
                "backend": ""
            },
            "logging": {
                "level": "debug"
            }
        },
        "server": {
            "port": 8000,
            "health_port": 1337,
            "ssl": false,
            "cert": "",
            "key": "",
            "readtimeout": 3600,
            "writetimeout": 3600,
            "idletimeout": 3600,
            "secure_cookie": false
        }
}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "auth-proxy-test.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "auth-proxy-test.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
