{% from 'lib.sls' import create_user, systemd %}

{#
  The `name` key must match the repository name of a Prometheus component: for example, prometheus.

  The backticked terms refer to keys in the Pillar data. The for-loop creates states to:

  - Create a `user`
  - Download and extract the specified `version` of the named component to the `user`'s home directory
  - Create `config`uration files in the user's home directory, if any
  - Create a systemd `service` file from a `salt/core/systemd/files/{service}.service` template,
    with access to `name`, `user` and `entry` variables
  - Start the `service`
#}
{% for name, entry in pillar.prometheus.items() %}

{% set userdir = '/home/' + entry.user %}

{{ create_user(entry.user) }}

# Note: This does not clean up old versions.
extract_{{ name }}:
  archive.extracted:
    - name: {{ userdir }}
    - source: https://github.com/prometheus/{{ name }}/releases/download/v{{ entry.version }}/{{ name }}-{{ entry.version }}.{{ grains.kernel|lower }}-{{ grains.osarch }}.tar.gz
    - source_hash: https://github.com/prometheus/{{ name }}/releases/download/v{{ entry.version }}/sha256sums.txt
    - user: {{ entry.user }}
    - group: {{ entry.user }}
    - require:
      - user: {{ entry.user }}_user_exists
    - require_in:
      - service: {{ entry.service }}

{% for filename, source in entry.config.items() %}
{{ userdir }}/{{ filename }}:
  file.managed:
    - {% if 'salt://' in source %}source{% else %}contents_pillar{% endif %}: {{ source }}
    - template: jinja
    - context:
        user: {{ entry.user }}
    - user: {{ entry.user }}
    - group: {{ entry.user }}
    - require:
      - user: {{ entry.user }}_user_exists
    # Make sure the service restarts if a configuration file changes.
    - watch_in:
      - module: {{ entry.service }}-reload
{% endfor %}

# https://github.com/prometheus/node_exporter/tree/master/examples/systemd
{{ systemd(entry) }}
{% endfor %}
