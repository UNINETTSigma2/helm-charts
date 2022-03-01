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
    "logout_redirect_url": "https://{{ .Values.ingress.host }}",
    "groups_endpoint": "{{- include "all_endpoints" . }}",
    "xhr_endpoints": "",
    "authorized_principals": "{{- join "," .Values.appstore_generated_data.dataporten.authorized_groups -}}",
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

{{- define "default.conf" -}}
{{ $hostid := randAlphaNum 8 }}
upstream backend {
  server  localhost:8787;
}

server {
  listen       8888;
  server_name  localhost;

  location / {

    proxy_pass http://backend;
    proxy_redirect http://backend/ https://{{ .Values.ingress.host }}/;
    proxy_redirect https://backend/ https://{{ .Values.ingress.host }}/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_read_timeout 20d;
    proxy_set_header X-RStudio-Request $scheme://$host:$server_port$request_uri;
  }

  error_page   500 502 503 504  /50x.html;
  location = /50x.html {
      root   /usr/share/nginx/html;
  }
}
{{- end -}}

{{- define "shiny-server.conf" -}}
# Instruct Shiny Server to run applications as the user "shiny"
run_as {{ .Values.username }};

{{- if .Values.advanced.debug }}
preserve_logs true;
{{- end }}

# Define a server that listens on port 3838
server {
  listen 3838;

  # Define a location at the base URL
  location / {

    # Host the directory of Shiny Apps stored in this directory
    site_dir /srv/shiny-server;

    # Log all Shiny output to files in this directory
    log_dir /var/log/shiny-server;

    # When a user visits the base URL rather than a particular application,
    # an index of the applications available in this directory will be shown.
    directory_index on;
  }
}

{{- end -}}

{{- define "passwd" -}}
# Create /etc/passwd file to contain UID of users we add

root:x:0:0:root:/root:/bin/bash
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
_apt:x:100:65534::/nonexistent:/bin/false
rstudio-server:x:988:988::/home/rstudio-server:
shiny:x:998:998::/home/shiny:
{{ if ne .Values.persistentStorage.existingClaim "" }}
{{ .Values.username }}:x:{{ .Values.uid }}:{{ .Values.gid }}::/home/{{ .Values.username }}:/bin/bash
{{ else }}
{{ .Values.username }}:x:{{ .Values.uid }}:{{ .Values.gid }}::/home/rstudio:/bin/bash
{{ end }}
rstudio:x:999:999::/home/rstudio:/bin/bash

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
staff:x:50:rstudio
games:x:60:
users:x:100:
nogroup:x:65534:
rstudio-server:x:988:
rstudio:x:999:
ssh:x:101:
shiny:x:998:
nogroup:x:65534:
{{- $firstGroup := .Values.supplementalGroups | first }}
{{- if $firstGroup.gid }}
{{- range .Values.supplementalGroups }}
{{- if .name }}
{{ .name }}:x:{{ .gid }}:
{{- end }}
{{- end }}
{{- end }}
rstudio:x:999:rstudio

{{- end -}}

# Create /etc/group file to contain UID of users we add
{{- define "shadow" -}}
root:*:17647:0:99999:7:::
daemon:*:17647:0:99999:7:::
bin:*:17647:0:99999:7:::
sys:*:17647:0:99999:7:::
sync:*:17647:0:99999:7:::
games:*:17647:0:99999:7:::
man:*:17647:0:99999:7:::
lp:*:17647:0:99999:7:::
mail:*:17647:0:99999:7:::
news:*:17647:0:99999:7:::
uucp:*:17647:0:99999:7:::
proxy:*:17647:0:99999:7:::
www-data:*:17647:0:99999:7:::
backup:*:17647:0:99999:7:::
list:*:17647:0:99999:7:::
irc:*:17647:0:99999:7:::
gnats:*:17647:0:99999:7:::
nobody:*:17647:0:99999:7:::
_apt:*:17647:0:99999:7:::
rstudio-server:!:17652::::::
{{ .Values.username }}:$6$OLWwdiLp$uLstyoh.dp5yAWgZqoHUj707hxKlca17PrGFoDKvOlX.QHJVdLBm3eBfG9JF0NKjgxCL8QKTl3xMR/LZJSmgR1:17652:0:99999:7:::
{{- end -}}

# Create rserver.conf
{{- define "rserver.conf" -}}
auth-required-user-group=rstudio
auth-minimum-user-id=100
rsession-which-r=/usr/local/bin/R
auth-none=1
server-user={{ .Values.username }}
{{ end }}

# Create rsession.conf
{{- define "rsession.conf" -}}
session-timeout-minutes=0
{{- if ne .Values.persistentStorage.existingClaim "" }}
session-default-working-dir=/home/{{ .Values.username }}
{{- else }}
session-default-working-dir=/home/rstudio
{{- end }}
{{ end }}

# Create .Renviron
{{- define ".Renviron" -}}
HOME=/home/rstudio
TZ=Europe/Oslo
USER={{ .Values.username }}
{{ end }}
