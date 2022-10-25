{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "oidcconfig" -}}
{
  "proxy": {
    "target": "http://localhost:8888"
  },
  "engine": {
    "client_id": "{{ .Values.appstore_generated_data.aai.client_id }}",
    "client_secret": "{{ .Values.appstore_generated_data.aai.client_secret }}",
    "issuer_url": "{{ .Values.appstore_generated_data.aai.issuer_url }}",
    "redirect_url": "https://{{ .Values.ingress.host }}/oauth2/callback",
    "scopes": "{{- join "," .Values.appstore_generated_data.aai.scopes -}}",
    "signkey": "",
    "token_type": "",
    "jwt_token_issuer": "",
    "groups_endpoint": "",
    "groups_claim": "principals",
    "username_claim": "sub",
    "xhr_endpoints": "",
    "authorized_principals": "{{- join "," .Values.appstore_generated_data.aai.authorized_principals -}}",
    "twofactor": {
      "all": false,
      "principals": "",
      "acr_values": "",
      "backend": ""
    },
    "logging": {
      "level": "info"
    }
  },
  "server": {
    "port": 8080,
    "health_port": 1337,
    "cert": "cert.pem",
    "key": "key.pem",
    "readtimeout": 10,
    "writetimeout": 20,
    "idletimeout": 120,
    "ssl": false,
    "secure_cookie": false
  }
}
{{- end -}}
