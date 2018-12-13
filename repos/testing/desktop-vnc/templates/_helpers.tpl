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
    "target": "http://localhost:6901/"
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
    "readtimeout": 3600,
    "writetimeout": 3600,
    "idletimeout": 3600,
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
c.NotebookApp.notebook_dir = '/home/{{ .Values.username }}'
{{ else }}
c.NotebookApp.notebook_dir = '/home/notebook'
{{ end }}
{{ if ne .Values.advanced.githubToken "" }}
c.GitHubConfig.access_token = '{{ .Values.advanced.githubToken }}'
{{ end }}
c.NotebookApp.allow_origin = '*'
c.NotebookApp.allow_remote_access = True
c.NotebookApp.token = ''
c.NotebookApp.password = ''

{{- end -}}

# Create /etc/passwd file to contain UID of users we add
{{- define "passwd" -}}
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin
jovyan:x:1000:100::/home/jovyan:/bin/bash
{{ .Values.username }}:x:{{ .Values.uid }}:{{ .Values.gid }}::/home/{{ .Values.username }}:/bin/bash
notebook:x:999:999::/home/notebook:/bin/bash

{{- end -}}

# Create /etc/group file to contain UID of users we add
{{- define "group" -}}
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:
tty:x:5:
disk:x:6:
lp:x:7:
mail:x:8:
news:x:9:
uucp:x:10:
man:x:12:
proxy:x:13:
kmem:x:15:
dialout:x:20:
fax:x:21:
voice:x:22:
cdrom:x:24:
floppy:x:25:
tape:x:26:
sudo:x:27:
audio:x:29:
dip:x:30:
www-data:x:33:
backup:x:34:
operator:x:37:
list:x:38:
irc:x:39:
src:x:40:
gnats:x:41:
shadow:x:42:
utmp:x:43:
video:x:44:
sasl:x:45:
plugdev:x:46:
staff:x:50:
games:x:60:
users:x:100:notebook
nogroup:x:65534:
wheel:x:11:
ssh:x:101:
{{ .Values.username }}:x:{{ .Values.gid }}:
{{- $firstGroup := .Values.supplementalGroups | first }}
{{- if $firstGroup.gid }}
{{- range .Values.supplementalGroups }}
{{- if .name }}
{{ .name }}:x:{{ .gid }}:
{{- end }}
{{- end }}
{{- end }}
notebook:x:999:

{{- end -}}
