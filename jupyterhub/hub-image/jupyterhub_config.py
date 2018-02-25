import os
import glob

import json
import base64
import urllib

from tornado.httpclient import AsyncHTTPClient, HTTPRequest
from oauthenticator.generic import GenericOAuthenticator
from kubernetes import client

from tornado import gen, web
from tornado.auth import OAuth2Mixin
from tornado.httputil import url_concat

from z2jh import get_config, get_secret

from jupyterhub.auth import LocalAuthenticator
from traitlets import Unicode, Dict
from oauthenticator.oauth2 import OAuthLoginHandler, OAuthenticator

class GenericEnvMixin(OAuth2Mixin):
    _OAUTH_ACCESS_TOKEN_URL = os.environ.get('OAUTH2_TOKEN_URL', '')
    _OAUTH_AUTHORIZE_URL = os.environ.get('OAUTH2_AUTHORIZE_URL', '')


class GenericLoginHandler(OAuthLoginHandler, GenericEnvMixin):
    pass


class DataportenAuth(OAuthenticator):

    login_service = Unicode(
        "Dataporten",
        config=True
    )

    login_handler = GenericLoginHandler

    userdata_url = Unicode(
        os.environ.get('OAUTH2_USERDATA_URL', ''),
        config=True,
        help="Userdata url to get user data login information"
    )
    token_url = Unicode(
        os.environ.get('OAUTH2_TOKEN_URL', ''),
        config=True,
        help="Access token endpoint URL"
    )

    username_key = Unicode(
        os.environ.get('OAUTH2_USERNAME_KEY', 'username'),
        config=True,
        help="Userdata username key from returned json for USERDATA_URL"
    )
    userdata_params = Dict(
        os.environ.get('OAUTH2_USERDATA_PARAMS', {}),
        help="Userdata params to get user data login information"
    ).tag(config=True)

    userdata_method = Unicode(
        os.environ.get('OAUTH2_USERDATA_METHOD', 'GET'),
        config=True,
        help="Userdata method to get user data login information"
    )

    authorized_groups = Unicode(
        os.environ.get('AUTHORIZED_GROUPS', ''),
        config=True,
        help="The groups that allowed to access the application. If none are specified, all groups are allowed access."
    )

    groups_url = Unicode(
        os.environ.get('GROUPS_URL', "https://groups-api.dataporten.no/groups/me/groups"),
        config=True,
        help="The groups URL to use when fetching groups."
    )

    @gen.coroutine
    def authenticate(self, handler, data=None):
        code = handler.get_argument("code")
        # TODO: Configure the curl_httpclient for tornado
        http_client = AsyncHTTPClient()

        params = dict(
            redirect_uri=self.get_callback_url(handler),
            code=code,
            grant_type='authorization_code'
        )

        if self.token_url:
            url = self.token_url
        else:
            raise ValueError("Please set the OAUTH2_TOKEN_URL environment variable")

        b64key = base64.b64encode(
            bytes(
                "{}:{}".format(self.client_id, self.client_secret),
                "utf8"
            )
        )

        headers = {
            "Accept": "application/json",
            "User-Agent": "JupyterHub",
            "Authorization": "Basic {}".format(b64key.decode("utf8"))
        }
        req = HTTPRequest(url,
                          method="POST",
                          headers=headers,
                          body=urllib.parse.urlencode(params)  # Body is required for a POST...
                          )

        resp = yield http_client.fetch(req)

        resp_json = json.loads(resp.body.decode('utf8', 'replace'))

        access_token = resp_json['access_token']
        refresh_token = resp_json.get('refresh_token', None)
        token_type = resp_json['token_type']
        scope = (resp_json.get('scope', '')).split(' ')

        # Determine who the logged in user is
        headers = {
            "Accept": "application/json",
            "User-Agent": "JupyterHub",
            "Authorization": "{} {}".format(token_type, access_token)
        }
        if self.userdata_url:
            url = url_concat(self.userdata_url, self.userdata_params)
        else:
            raise ValueError("Please set the OAUTH2_USERDATA_URL environment variable")

        req = HTTPRequest(url,
                          method=self.userdata_method,
                          headers=headers,
                          )
        resp = yield http_client.fetch(req)
        resp_json = json.loads(resp.body.decode('utf8', 'replace'))

        if not resp_json.get(self.username_key):
            self.log.error("OAuth user contains no key %s: %s", self.username_key, resp_json)
            return

        if self.authorized_groups:
            groups_req = HTTPRequest(self.groups_url,
                                     method="GET",
                                     headers=headers
            )
            groups_resp = yield http_client.fetch(groups_req)
            groups_resp_json = json.loads(groups_resp.body.decode('utf8', 'replace'))

            # Determine whether the user is member of one of the authorized groups
            user_group_id = [g["id"] for g in groups_resp_json]
            authorized = False
            for group_id in self.authorized_groups.split(","):
                if group_id in user_group_id:
                    authorized = True

            if not authorized:
                return

        return {
            'name': resp_json.get(self.username_key),
            'auth_state': {
                'access_token': access_token,
                'refresh_token': refresh_token,
                'oauth_user': resp_json,
                'scope': scope,
            }
        }


class LocalGenericOAuthenticator(LocalAuthenticator, DataportenAuth):

    """A version that mixes in local system user creation"""
    pass

# Configure JupyterHub to use the curl backend for making HTTP requests,
# rather than the pure-python implementations. The default one starts
# being too slow to make a large number of requests to the proxy API
# at the rate required.
AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient")

c.JupyterHub.spawner_class = 'kubespawner.KubeSpawner'

# Connect to a proxy running in a different pod
api_proxy_service_name = os.environ["PROXY_API_SERVICE_NAME"]
c.ConfigurableHTTPProxy.api_url = 'http://{}:{}'.format(os.environ[api_proxy_service_name + "_HOST"], int(os.environ[api_proxy_service_name + "_PORT"]))
c.ConfigurableHTTPProxy.should_start = False

# Do not shut down user pods when hub is restarted
c.JupyterHub.cleanup_servers = False

# Check that the proxy has routes appropriately setup
# This isn't the best named setting :D
c.JupyterHub.last_activity_interval = 60

# Max number of servers that can be spawning at any one time
c.JupyterHub.concurrent_spawn_limit = get_config('hub.concurrent-spawn-limit')

active_server_limit = get_config('hub.active-server-limit', None)

if active_server_limit is not None:
    c.JupyterHub.active_server_limit = int(active_server_limit)

public_proxy_service_name = os.environ["PROXY_PUBLIC_SERVICE_NAME"]
c.JupyterHub.ip = os.environ[public_proxy_service_name + "_HOST"]
c.JupyterHub.port = int(os.environ[public_proxy_service_name + "_PORT"])

# the hub should listen on all interfaces, so the proxy can access it
c.JupyterHub.hub_ip = '0.0.0.0'

c.KubeSpawner.namespace = os.environ.get('POD_NAMESPACE', 'default')

c.KubeSpawner.start_timeout = get_config('singleuser.start-timeout')

# Use env var for this, since we want hub to restart when this changes
c.KubeSpawner.singleuser_image_spec = os.environ['SINGLEUSER_IMAGE']

c.KubeSpawner.singleuser_extra_labels = get_config('singleuser.extra-labels', {})

c.KubeSpawner.singleuser_uid = get_config('singleuser.uid')
c.KubeSpawner.singleuser_fs_gid = get_config('singleuser.fs-gid')

service_account_name = get_config('singleuser.service-account-name', None)
if service_account_name:
    c.KubeSpawner.singleuser_service_account = service_account_name

c.KubeSpawner.singleuser_node_selector = get_config('singleuser.node-selector')
# Configure dynamically provisioning pvc
storage_type = get_config('singleuser.storage.type')
if storage_type == 'dynamic':
    c.KubeSpawner.pvc_name_template = 'claim-{username}{servername}'
    c.KubeSpawner.user_storage_pvc_ensure = True
    storage_class = get_config('singleuser.storage.dynamic.storage-class', None)
    if storage_class:
        c.KubeSpawner.user_storage_class = storage_class
    c.KubeSpawner.user_storage_access_modes = ['ReadWriteOnce']
    c.KubeSpawner.user_storage_capacity = get_config('singleuser.storage.capacity')

    # Add volumes to singleuser pods
    c.KubeSpawner.volumes = [
        {
            'name': 'volume-{username}{servername}',
            'persistentVolumeClaim': {
                'claimName': 'claim-{username}{servername}'
            }
        }
    ]
    c.KubeSpawner.volume_mounts = [
        {
            'mountPath': get_config('singleuser.storage.home_mount_path'),
            'name': 'volume-{username}{servername}'
        }
    ]
elif storage_type == 'static':
    pvc_claim_name = get_config('singleuser.storage.static.pvc-name')
    c.KubeSpawner.volumes = [{
        'name': 'home',
        'persistentVolumeClaim': {
            'claimName': pvc_claim_name
        }
    }]

    c.KubeSpawner.volume_mounts = [{
        'mountPath': get_config('singleuser.storage.home_mount_path'),
        'name': 'home',
        'subPath': get_config('singleuser.storage.static.sub-path')
    }]

c.KubeSpawner.volumes.extend(get_config('singleuser.storage.extra-volumes', []))
c.KubeSpawner.volume_mounts.extend(get_config('singleuser.storage.extra-volume-mounts', []))

lifecycle_hooks = get_config('singleuser.lifecycle-hooks')
if lifecycle_hooks:
    c.KubeSpawner.singleuser_lifecycle_hooks = lifecycle_hooks

init_containers = get_config('singleuser.init-containers')
if init_containers:
    c.KubeSpawner.singleuser_init_containers.extend(init_containers)

# Gives spawned containers access to the API of the hub
hub_service_name = os.environ["HUB_SERVICE_NAME"]
c.KubeSpawner.hub_connect_ip = os.environ[hub_service_name + "_HOST"]
c.KubeSpawner.hub_connect_port = int(os.environ[hub_service_name + '_PORT'])

c.JupyterHub.hub_connect_ip = os.environ[hub_service_name + "_HOST"]
c.JupyterHub.hub_connect_port = int(os.environ[hub_service_name + "_PORT"])

c.KubeSpawner.mem_limit = get_config('singleuser.memory.limit')
c.KubeSpawner.mem_guarantee = get_config('singleuser.memory.guarantee')
c.KubeSpawner.cpu_limit = get_config('singleuser.cpu.limit')
c.KubeSpawner.cpu_guarantee = get_config('singleuser.cpu.guarantee')

# Allow switching authenticators easily
auth_type = get_config('auth.type')
email_domain = 'local'

c.JupyterHub.authenticator_class =  DataportenAuth
c.OAuthenticator.login_service = 'Dataporten'

c.OAuthenticator.client_id = os.environ["OAUTH_CLIENT_ID"]
c.OAuthenticator.client_secret = os.environ["OAUTH_CLIENT_SECRET"]

c.DataportenAuth.token_url = 'https://auth.dataporten.no/oauth/token'
c.DataportenAuth.oauth_callback_url = os.environ["OAUTH_CALLBACK_URL"]

c.DataportenAuth.userdata_url  = 'https://auth.dataporten.no/openid/userinfo'
c.DataportenAuth.userdata_method = 'GET'
c.DataportenAuth.username_key = 'sub'

c.Authenticator.enable_auth_state = get_config('auth.state.enabled', False)

def generate_user_email(spawner):
    """
    Used as the EMAIL environment variable
    """
    return '{username}@{domain}'.format(
        username=spawner.user.name, domain=email_domain
    )

def generate_user_name(spawner):
    """
    Used as GIT_AUTHOR_NAME and GIT_COMMITTER_NAME environment variables
    """
    return spawner.user.name

c.KubeSpawner.environment = {
    'EMAIL': generate_user_email,
    # git requires these committer attributes
    'GIT_AUTHOR_NAME': generate_user_name,
    'GIT_COMMITTER_NAME': generate_user_name
}

c.KubeSpawner.environment.update(get_config('singleuser.extra-env', {}))

# Enable admins to access user servers
c.JupyterHub.admin_access = get_config('auth.admin.access')
c.Authenticator.admin_users = get_config('auth.admin.users', [])
c.Authenticator.whitelist = get_config('auth.whitelist.users', [])

c.JupyterHub.base_url = get_config('hub.base_url')

c.JupyterHub.services = []

if get_config('cull.enabled', False):
    cull_timeout = get_config('cull.timeout')
    cull_every = get_config('cull.every')
    cull_cmd = [
        '/usr/local/bin/cull_idle_servers.py',
        '--timeout=%s' % cull_timeout,
        '--cull-every=%s' % cull_every,
        '--url=http://127.0.0.1:8081' + c.JupyterHub.base_url + 'hub/api'
    ]
    if get_config('cull.users'):
        cull_cmd.append('--cull-users')
    c.JupyterHub.services.append({
        'name': 'cull-idle',
        'admin': True,
        'command': cull_cmd,
    })

for name, service in get_config('hub.services', {}).items():
    api_token = get_secret('services.token.%s' % name)
    # jupyterhub.services is a list of dicts, but
    # in the helm chart it is a dict of dicts for easier merged-config
    service.setdefault('name', name)
    if api_token:
        service['api_token'] = api_token
    c.JupyterHub.services.append(service)


c.JupyterHub.db_url = get_config('hub.db_url')

cmd = get_config('singleuser.cmd', None)
if cmd:
    c.Spawner.cmd = cmd

default_url = get_config('singleuser.default-url', None)
if default_url:
    c.Spawner.default_url = default_url

scheduler_strategy = get_config('singleuser.scheduler-strategy', 'spread')

if scheduler_strategy == 'pack':
    # FIXME: Support setting affinity directly in KubeSpawner
    c.KubeSpawner.singleuser_extra_pod_config = {
        'affinity': {
            'podAffinity': {
                'preferredDuringSchedulingIgnoredDuringExecution': [{
                    'weight': 100,
                    'podAffinityTerm': {
                        'labelSelector': {
                            'matchExpressions': [{
                                'key': 'component',
                                'operator': 'In',
                                'values': ['singleuser-server']
                            }]
                        },
                        'topologyKey': 'kubernetes.io/hostname'
                    }
                }],
            }
        }
    }
else:
    # Set default to {} so subconfigs can easily update it
    c.KubeSpawner.singleuser_extra_pod_config = {}

extra_configs = sorted(glob.glob('/etc/jupyterhub/config/hub.extra-config.*.py'))
for ec in extra_configs:
    load_subconfig(ec)
