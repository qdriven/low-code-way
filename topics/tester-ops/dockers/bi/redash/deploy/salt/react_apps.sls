{% from 'lib.sls' import apache %}

include:
  - apache
  - apache.modules.rewrite

{% for name, entry in pillar.react_apps.items() %}

# A user might run multiple apps, so the user is not created here.
{% set userdir = '/home/' + entry.user %}
{% set directory = userdir + '/' + entry.git.target %}
{% set appdir = userdir + '/web/current' %}
{% set context = {'name': name, 'entry': entry, 'appdir': appdir} %}

{{ entry.git.url }}:
  git.latest:
    - name: {{ entry.git.url }}
    - user: {{ entry.user }}
    - force_fetch: True
    - force_reset: True
    - branch: {{ entry.git.branch }}
    - rev: {{ entry.git.branch }}
    - target: {{ directory }}
    - require:
      - pkg: git
      - user: {{ entry.user }}_user_exists

{{ appdir }}:
  file.symlink:
    - target: {{ directory }}
    - makedirs: True
    - runas: {{ entry.user }}
    - require:
      - git: {{ entry.git.url }}
    # The symlink must be created before Apache starts.
    - require_in:
      - service: apache2

{% if 'apache' in entry %}
{{ apache(entry.git.target, entry.apache, context=context) }}
{% endif %}

{{ userdir }}-nvm-installer:
  file.managed:
    - name: {{ userdir }}/nvm-install.sh
    - source: https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh
    # curl -sS https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | shasum
    - source_hash: e70e16f272f4ce4cc3e8d98e1e0ead449ab9ae5c
    - user: {{ entry.user }}
    - group: {{ entry.user }}
    - mode: 755

{{ userdir }}-nvm-install:
  cmd.run:
    - name: bash {{ userdir }}/nvm-install.sh
    - runas: {{ entry.user }}
    - cwd: {{ userdir }}
    - require:
      - pkg: git
    - onchanges:
      - file: {{ userdir }}-nvm-installer

{% endfor %}
