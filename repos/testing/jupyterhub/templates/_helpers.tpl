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

{{- define "ipcontroller_config" -}}
{
  "ssh": "",
  "interface": "tcp://*",
  "registration": 9001,
  "control": 9002,
  "mux": 9003,
  "hb_ping": 9004,
  "hb_pong": 9005,
  "task": 9006,
  "iopub": 9007,
  "key": "{{ .randomKey }}",
  "location": "{{  .Release.Name }}-ipycontroller",
  "pack": "json",
  "unpack": "json",
  "signature_scheme": "hmac-sha256"
}
{{- end -}}

{{- define "ipcontroller_client_config" -}}
{
  "ssh": "",
  "interface": "tcp://*",
  "registration": 9001,
  "control": 10002,
  "mux": 10003,
  "task": 10004,
  "iopub": 10005,
  "task_scheme": "leastload",
  "notification": 10006,
  "key": "{{ .randomKey }}",
  "location": "{{  .Release.Name }}-ipycontroller",
  "pack": "json",
  "unpack": "json",
  "signature_scheme": "hmac-sha256"
}
{{- end -}}

{{- define "subPath" -}}
  {{- if eq .subPath "/" }}
    {{- printf "" }}
  {{- else }}
    {{- printf "%s/" .subPath }}
  {{- end }}
{{- end -}}

{{- define "supplemental_groups_list" -}}
    {{- $n_groups := sub (len .Values.supplementalGroups) 1 }}
    {{- printf "[" }}
    {{- range $index, $el := .Values.supplementalGroups }}
	{{- print $el.gid }}
	{{- if lt $index $n_groups }}
	    {{- printf "," }}
	{{- end }}
    {{- end }}
    {{- printf "]" }}
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
notebook:x:999:999::/home/notebook:/bin/bash
hub:x:{{ .Values.uid }}:{{ .Values.gid }}::/home/notebook:/bin/bash
{{- end -}}

# Create /etc/passwd file to contain UID of users we add
{{- define "vnc-passwd" -}}
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
notebook:x:999:999::/home/notebook:/bin/bash
vncuser:x:{{ .Values.uid }}:{{ .Values.gid }}::/home/vncuser:/bin/bash
{{- end -}}

# Create /etc/passwd file to contain UID of users we add
{{- define "minio-passwd" -}}
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
{{ .Values.username }}:x:{{ .Values.uid }}:{{ .Values.gid }}::/home/notebook:/bin/bash
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

# Create /etc/group file to contain UID of users we add
{{- define "vnc-group" -}}
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
users:x:100:vncuser
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
vncuser:x:999:
{{- end -}}

# Create /etc/group file to contain UID of users we add
{{- define "minio-group" -}}
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

{{- end -}}


{{- define "jupyterhub.randHex" -}}
    {{- $result := "" }}
    {{- range $i := until . }}
        {{- $rand_hex_char := mod (randNumeric 4 | atoi) 16 | printf "%x" }}
        {{- $result = print $result $rand_hex_char }}
    {{- end }}
    {{- $result }}
{{- end }}


{{- define "values.yaml" -}}
    {{- /* Cull */}}
    {{- if .Values.advanced.killIdlePods.enabled }}
    cull:
      enabled: "true"
      users: "false"
      timeout: {{ .Values.advanced.killIdlePods.timeout | quote }}
      every: "600"
      concurrency: {{ .Values.advanced.killIdlePods.concurrency | quote }}
    {{- end }}

    {{- /* Singleuser */}}
    singleuser:
      image:
        name: "{{ .Values.advanced.userImage }}"
        pullPolicy: IfNotPresent
        volumeMounts:
          - name: "passwd"
            mountPath: "/etc/passwd"
            subPath: "passwd"
          - name: "group"
            mountPath: "/etc/group"
            subPath: "group"
      startTimeout: {{ .Values.advanced.startTimeout }}
      scheduler-strategy: pack
      uid: 999
      fsGid: {{ .Values.gid }}
      {{- if .Values.advanced.jupyterLab }}
      defaultUrl: "/lab"
      {{- end }}
      extraEnv:
        RELEASE_NAME: "{{ .Release.Name }}"
        JUPYTER_HUB: "1"
        PVC_MOUNT_PATH: /mnt/data
        {{- if .Values.advanced.jupyterLab }}
        JUPYTER_ENABLE_LAB: "1"
        {{- end }}
      {{ $firstGroup := .Values.supplementalGroups | first }}
      {{- if $firstGroup.gid }}
      supplemental-gids:
        {{- range .Values.supplementalGroups }}
        - {{ .gid }}
        {{- end }}
      {{- end }}
      serviceAccountName: "default"
      podNameTemplate: "{{.Release.Name}}-jupyter-{username}"
      nodeSelector: {}
      storage:
        extraVolumes:
          - name: "passwd"
            configMap:
              name: "{{ template "fullname" . }}"
              items:
                - key: "passwd"
                  path: "passwd"
          - name: "group"
            configMap:
              name: "{{ template "fullname" . }}"
              items:
                - key: "group"
                  path: "group"
          - name: "vnc-passwd"
            configMap:
              name: "{{ template "fullname" . }}-vnc"
              items:
                - key: "passwd"
                  path: "passwd"
          - name: "vnc-group"
            configMap:
              name: "{{ template "fullname" . }}-vnc"
              items:
                - key: "group"
                  path: "group"
          - name: "shm"
            emptyDir:
              medium: "Memory"
              sizeLimit: "256M"
          {{- if .Values.advanced.ipyparallel.enabled }}
          - name: ipyparallel-config
            secret:
              secretName: {{ .Release.Name }}-ipyparallel-config
          {{- end }}
          {{- if ne (first .Values.persistentStorage).existingClaim "" }}
          {{- range .Values.persistentStorage }}
          - name: {{ .existingClaimName }}
            persistentVolumeClaim:
              claimName: {{ .existingClaim }}
          {{- end }}
          {{- end }}
        extraVolumeMounts:
          - name: "shm"
            mountPath: "/dev/shm"
          {{- if .Values.advanced.ipyparallel.enabled }}
          - name: ipyparallel-config
            mountPath: /tmp/ipcontroller-client.json
            mountPropagation: "HostToContainer"
            subPath: ipcontroller-client.json
            readOnly: true
          {{- end }}
          {{- if ne (first .Values.persistentStorage).existingClaim "" }}
          {{- $sharedSubPath := .Values.advanced.sharedData.subPath }}
          {{- $sharedReadOnly := .Values.advanced.sharedData.readOnly }}
          {{- if .Values.advanced.sharedData.enabled }}
          {{- range .Values.persistentStorage }}
          - name: "{{ .existingClaimName }}"
            mountPath: "/mnt/{{ .existingClaimName }}"
            mountPropagation: "HostToContainer"
            subPath: "{{ template "subPath" . }}{{ $sharedSubPath }}"
            readOnly: {{ $sharedReadOnly }}
          {{- end }}
          {{- end }}
          {{- end }}
        {{- if ne (first .Values.persistentStorage).existingClaim "" }}
        type: "static"
        static:
          pvcName: "{{ (first .Values.persistentStorage).existingClaimName }}"
          {{- if .Values.advanced.userHomeAddStorageSubPath }}
          subPath: "{{ template "subPath" (first .Values.persistentStorage) }}{{ .Values.advanced.userHomeSubPath }}/{username}"
          {{- else }}
          subPath: "{{ .Values.advanced.userHomeSubPath }}/{username}"
          {{- end }}
        {{- else }}
        type: "none"
        {{- end }}
        homeMountPath: "/home/{username}"
      {{- if or .Values.userNotebookType.resources.requests.memory .Values.userNotebookType.resources.limits.memory }}
      memory:
        {{- if .Values.userNotebookType.resources.requests.memory }}
        guarantee: {{ .Values.userNotebookType.resources.requests.memory | quote}}
        {{- end }}
        {{- if .Values.userNotebookType.resources.limits.memory }}
        limit: {{ .Values.userNotebookType.resources.limits.memory | quote }}
        {{- end }}
      {{- end }}
      {{- if or .Values.userNotebookType.resources.requests.cpu .Values.userNotebookType.resources.limits.cpu }}
      cpu:
        {{- if .Values.userNotebookType.resources.requests.cpu }}
        guarantee: {{ .Values.userNotebookType.resources.requests.cpu }}
        {{- end }}
        {{- if .Values.userNotebookType.resources.limits.cpu }}
        limit: {{ .Values.userNotebookType.resources.limits.cpu }}
        {{- end }}
      {{- end }}
      {{- if or .Values.userNotebookType.resources.requests.gpu .Values.userNotebookType.resources.limits.gpu }}
      extraResource:
        {{- if .Values.userNotebookType.resources.requests.gpu }}
        guarantees:
          nvidia.com/gpu: {{ .Values.userNotebookType.resources.requests.gpu }}
        {{- end }}
        {{- if .Values.userNotebookType.resources.limits.gpu }}
        limits:
          nvidia.com/gpu: {{ .Values.userNotebookType.resources.requests.gpu }}
        {{- end }}
      {{- end }}
      extraLabels:
        hub.jupyter.org/network-access-hub: "true"
      {{- if .Values.advanced.vnc.enabled }}
      extraContainers:
        - name: "viz"
          image: "{{ .Values.advanced.vnc.image }}"
          imagePullPolicy: IfNotPresent
          securityContext:
            runAsUser: {{ .Values.uid }}
            runAsGroup: {{ .Values.gid }}
          args: ["-w"]
          ports:
            - containerPort: 6901
          env:
            - name: "VNC_PW"
              value: "test"
            - name: "HOME"
              value: "/home/vncuser"
          volumeMounts:
            - name: "vnc-passwd"
              mountPath: "/etc/passwd"
              subPath: "passwd"
            - name: "vnc-group"
              mountPath: "/etc/group"
              subPath: "group"
            - name: "shm"
              mountPath: "/dev/shm"
            {{- if ne (first .Values.persistentStorage).existingClaim "" }}
            - name: {{ (first .Values.persistentStorage).existingClaimName }}
              mountPath: "/home/notebook"
              mountPropagation: "HostToContainer"
              subPath: "{{ template "subPath" (first .Values.persistentStorage) }}{{ .Values.advanced.userHomeSubPath }}/{username}"
            {{- end }}
          resources:
            requests:
              cpu: "{{ .Values.advanced.vnc.resources.requests.cpu }}"
              memory: "{{ .Values.advanced.vnc.resources.requests.memory }}"
            limits:
              cpu: "{{ .Values.advanced.vnc.resources.limits.cpu }}"
              memory: "{{ .Values.advanced.vnc.resources.limits.memory }}"
      {{- end }}

    custom:
      commonLabels:
        group: {{ .Release.Name }}-jupyterhub
        release: {{ .Release.Name }}
        heritage: {{ .Release.Service }}

    hub:
      base_url: "/"
      db_url: "sqlite:///jupyterhub.sqlite" # Use in memory
      concurrentSpawnLimit: {{ .Values.advanced.notebook.spawnLimit | quote }}
      config:
        DataportenAuth:
          login_service: "Dataporten"
          client_id: "{{ .Values.appstore_generated_data.dataporten.id }}"
          client_secret: "{{ .Values.appstore_generated_data.dataporten.client_secret }}"
          token_url: https://auth.dataporten.no/oauth/token
          userdata_method: GET
          userdata_params: {'state', 'state'}
          username_key: sub
          admin-users:
            - {{ .Values.appstore_generated_data.dataporten.owner }}
            {{- if ne (first .Values.advanced.additionalAdmin) "" }}
            {{- range .Values.advanced.additionalAdmin }}
            - {{ . }}
            {{- end }}
            {{- end }}
        JupyterHub:
          authenticator_class: oauthenticator.dataporten.DataportenAuth
      extraConfig:
        myConfig.py: |
          c.Spawner.http_timeout = {{ .Values.advanced.startTimeout }}
          c.Spawner.start_timeout = {{ .Values.advanced.startTimeout }}
          c.JupyterHub.cookie_secret_file = "/srv/jupyterhub/jupyterhub_cookie_secret"
          c.JupyterHub.ip = f'{get_name_env("proxy-http", "_SERVICE_HOST")}'
          c.JupyterHub.port = int(f'{get_name_env("proxy-http", "_SERVICE_PORT")}')
          c.KubeSpawner.uid = get_config('singleuser.run_as_gid', 999)
          c.KubeSpawner.gid = get_config('singleuser.run_as_gid', 999)
          c.KubeSpawner.supplemental_gids = get_config('singleuser.supplemental-gids', [])
          c.KubeSpawner.pod_name_template = get_config('singleuser.pod-name-template', 'jupyter-{username}{servername}')
          c.KubeSpawner.common_labels.update(get_config('custom.commonLabels', {}))
          # Gives spawned containers access to the API of the hub
          c.KubeSpawner.hub_connect_url = f'http://{get_name("hub")}:{get_name_env("hub", "_SERVICE_PORT")}'
          # Extra containers
          extra_containers = get_config('singleuser.extra-containers', None)
          if extra_containers:
              c.KubeSpawner.extra_containers = extra_containers
          # Persistent volume
          if (get_config('singleuser.storage.type') == 'static'):
              c.KubeSpawner.volumes.pop(0)
              c.KubeSpawner.volume_mounts[0]['name'] = get_config('singleuser.storage.static.pvcName', 'shared')
          import string
          import escapism
          safe_chars = set(string.ascii_lowercase + string.digits)
          c.KubeSpawner.environment["HOME"] = lambda spawner: "/home/{}".format(escapism.escape(str(spawner.user.name), safe=safe_chars, escape_char='-').lower())
      extraenv:
        OAUTH2_AUTHORIZE_URL: https://auth.dataporten.no/oauth/authorization
        OAUTH2_TOKEN_URL: https://auth.dataporten.no/oauth/token
        OAUTH2_CALLBACK_URL: https://{{ .Values.ingress.host }}/hub/oauth_callback
    debug:
      enabled: {{ .Values.advanced.debug | quote }}
{{- end }}