{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "minioconfig" -}}
{
  "version": "23",
  "credential": {
    "accessKey": "{{ randAlphaNum 20 }}",
    "secretKey": "{{ randAlphaNum 40 }}"
  },
  "region": "",
  "browser": "on",
  "domain": "",
  "storageclass": {
    "standard": "",
    "rrs": ""
  },
  "cache": {
    "drives": [],
    "expiry": 90,
    "exclude": []
  },
  "notify": {
    "amqp": {
      "1": {
        "enable": false,
        "url": "",
        "exchange": "",
        "routingKey": "",
        "exchangeType": "",
        "deliveryMode": 0,
        "mandatory": false,
        "immediate": false,
        "durable": false,
        "internal": false,
        "noWait": false,
        "autoDeleted": false
      }
    },
    "elasticsearch": {
      "1": {
        "enable": false,
        "format": "",
        "url": "",
        "index": ""
      }
    },
    "kafka": {
      "1": {
        "enable": false,
        "brokers": null,
        "topic": ""
      }
    },
    "mqtt": {
      "1": {
        "enable": false,
        "broker": "",
        "topic": "",
        "qos": 0,
        "clientId": "",
        "username": "",
        "password": "",
        "reconnectInterval": 0,
        "keepAliveInterval": 0
      }
    },
    "mysql": {
      "1": {
        "enable": false,
        "format": "",
        "dsnString": "",
        "table": "",
        "host": "",
        "port": "",
        "user": "",
        "password": "",
        "database": ""
      }
    },
    "nats": {
      "1": {
        "enable": false,
        "address": "",
        "subject": "",
        "username": "",
        "password": "",
        "token": "",
        "secure": false,
        "pingInterval": 0,
        "streaming": {
          "enable": false,
          "clusterID": "",
          "clientID": "",
          "async": false,
          "maxPubAcksInflight": 0
        }
      }
    },
    "postgresql": {
      "1": {
        "enable": false,
        "format": "",
        "connectionString": "",
        "table": "",
        "host": "",
        "port": "",
        "user": "",
        "password": "",
        "database": ""
      }
    },
    "redis": {
      "1": {
        "enable": false,
        "format": "",
        "address": "",
        "password": "",
        "key": ""
      }
    },
    "webhook": {
      "1": {
        "enable": false,
        "endpoint": ""
      }
    }
  }
}
{{- end -}}
