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

  if ($http_cookie !~ "hostid={{ $hostid }}" ) {
    set $state I;
  }

  if ($cookie_user-id) {
    set $state "${state}U";
  }

  location /js/encrypt.min.js {
    proxy_pass   http://backend$request_uri;
    break;
  }
  location /auth-public-key {
    proxy_pass   http://backend$request_uri;
    break;
  }
  location /auth-do-sign-in {
    proxy_pass   http://backend$request_uri;
    proxy_redirect https://backend/ https://{{ .Values.ingress.host }}/;
    break;
  }
  location /auth-sign-in {
    return 301 https://{{ .Values.ingress.host }}/oauth2/logout;
    break;
  }

  location / {
    if ($state = IU) {
	add_header Set-Cookie "hostid={{ $hostid }}";
	add_header Set-Cookie "user-id=deleted; Expires=Thu, 01-Jan-1970 00:00:01 GMT";
    }

    if ($state = U) {
	add_header Set-Cookie "hostid={{ $hostid }}";
	proxy_pass   http://backend$request_uri;
	break;
    }

    add_header Set-Cookie "hostid={{ $hostid }}";
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_redirect https://backend/ https://{{ .Values.ingress.host }}/;
    root /usr/share/nginx/html;
    proxy_read_timeout 20d;
  }

  error_page   500 502 503 504  /50x.html;
  location = /50x.html {
      root   /usr/share/nginx/html;
  }
}
{{- end -}}
