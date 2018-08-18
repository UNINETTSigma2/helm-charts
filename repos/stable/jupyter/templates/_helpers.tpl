{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "all_endpoints" -}}
    {{- $n_groups := sub (len .Values.authGroupProviders) 1 }}
    {{- range $index, $el := .Values.authGroupProviders }}
	{{- printf "%s" .url }}
	{{- if lt $index $n_groups }}
	    {{- printf "," }}
	{{- end }}
    {{- end }}
{{- end -}}

{{- define "oidcconfig" -}}
{
  "proxy": {
    "target": "http://localhost:8888"
  },
  "engine": {
    "client_id": "{{ .Values.appstore_generated_data.dataporten.id }}",
    "client_secret": "{{ .Values.appstore_generated_data.dataporten.client_secret }}",
    "issuer_url": "https://auth.dataporten.no",
    "redirect_url": "https://{{ .Values.ingress.host }}/oauth2/callback",
    "scopes": "{{- join "," .Values.appstore_generated_data.dataporten.scopes -}}",
    "signkey": "{{ randAlphaNum 60 }}",
    "token_type": "",
    "jwt_token_issuer": "",
    "groups_endpoint": "{{- include "all_endpoints" . }}",
    "authorized_principals": "{{- join "," .Values.appstore_generated_data.dataporten.authorized_groups -}}",
    "xhr_endpoints": "",
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

{{- define "notebook-config" -}}
# Configuration file for ipython-notebook.

c = get_config()

# ------------------------------------------------------------------------------
# NotebookApp configuration
# ------------------------------------------------------------------------------

c.IPKernelApp.pylab = 'inline'
c.NotebookApp.ip = '127.0.0.1'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.NotebookApp.base_url = '/'
c.NotebookApp.trust_xheaders = True
c.NotebookApp.tornado_settings = {'static_url_prefix': '/static/'}
{{ if ne .Values.persistentStorage.existingClaim "" }}
c.NotebookApp.notebook_dir = '/mnt/{{ .Values.persistentStorage.existingClaimName }}'
{{ else }}
c.NotebookApp.notebook_dir = '/home/notebook'
{{ end }}
{{ if ne .Values.advanced.githubToken "" }}
c.GitHubConfig.access_token = '{{ .Values.advanced.githubToken }}'
{{ end }}
c.NotebookApp.allow_origin = '*'
c.NotebookApp.token = ''
c.NotebookApp.password = ''

{{- end -}}
