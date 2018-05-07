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
    "client_id": "{{ .Values.appstore_generated_data.dataporten.id }}",
    "client_secret": "{{ .Values.appstore_generated_data.dataporten.client_secret }}",
    "issuer_url": "https://auth.dataporten.no",
    "redirect_url": "https://{{ .Values.ingress.host }}/oauth2/callback",
    "scopes": "{{- join "," .Values.appstore_generated_data.dataporten.scopes -}}",
    "signkey": "{{ randAlphaNum 60 }}",
    "token_type": "",
    "jwt_token_issuer": "",
    "groups_endpoint": "https://groups-api.dataporten.no/groups/me/groups",
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
upstream backend {
  server  localhost:8787;
}

server {
  listen       8888;
  server_name  localhost;

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
    proxy_redirect http://backend/ https://{{ .Values.ingress.host }}/;

    break;
  }
  location /auth-sign-in {
    return 301 https://{{ .Values.ingress.host }}/logout.html;
    break;
  }
  location /logout.html {
    root /usr/share/nginx/html;
    add_header Set-Cookie "goidc0=42;Path=/";
    break;
  }
  location / {
    if ($cookie_user-id) {
      proxy_pass   http://backend$request_uri;
      break;
    }
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_redirect http://backend/ https://{{ .Values.ingress.host }}/;
    root /usr/share/nginx/html;
  }

  error_page   500 502 503 504  /50x.html;
  location = /50x.html {
      root   /usr/share/nginx/html;
  }
}
{{- end -}}
