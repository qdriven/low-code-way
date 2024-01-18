# Defines common macros.

{% macro set_firewall(setting_name, setting_value="yes") %}
set {{ setting_name }} firewall setting:
  file.replace:
    - name:  /home/sysadmin-tools/firewall-settings.local
    - pattern: "{{ setting_name }}=.*"
    - repl: "{{ setting_name }}=\"{{ setting_value }}\""
    - append_if_not_found: True
{% endmacro %}

{% macro unset_firewall(setting_name) %}
unset {{ setting_name }} firewall setting:
  file.replace:
    - name:  /home/sysadmin-tools/firewall-settings.local
    - pattern: "{{ setting_name }}=.*"
    - repl: "{{ setting_name }}=\"\""
    - ignore_if_missing: True
{% endmacro %}

# It is safe to use `[]` as a default value, because the default value is never mutated.
{% macro create_user(user, authorized_keys=[]) %}
{{ user }}_user_exists:
  user.present:
    - name: {{ user }}
    - home: /home/{{ user }}
    - order: 1
    - shell: /bin/bash

{{ user }}_authorized_keys:
  ssh_auth.manage:
    - user: {{ user }}
    - ssh_keys: {{ (pillar.ssh.admin + salt['pillar.get']('ssh:root', []) + authorized_keys)|yaml }}
    - require:
      - user: {{ user }}_user_exists
{% endmacro %}

{#
  Accepts an `entry` object with a `service` key for the name of the service, a `user` key for the user to run the
  service, and any other keys to be passed to the `*.service` template.
#}
# https://www.freedesktop.org/software/systemd/man/systemd.directives.html
{% macro systemd(entry) %}
/etc/systemd/system/{{ entry.service }}.service:
  file.managed:
    - source: salt://core/systemd/files/{{ entry.service }}.service
    - template: jinja
    - context:
        user: {{ entry.user }}
        entry: {{ entry|yaml }}
    - watch_in:
      - service: {{ entry.service }}

{{ entry.service }}:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/{{ entry.service }}.service

{{ entry.service }}-reload:
  module.wait:
    - name: service.reload
    - m_name: {{ entry.service }}
{% endmacro %}

{#
  Accepts a `name` string used to name configuration files, an `entry` object with Apache configuration, and a
  `context` object, whose keys are made available as variables in the configuration template.

  See https://ocdsdeploy.readthedocs.io/en/latest/develop/update/apache.html
#}
# It is safe to use `{}` as a default value, because the default value is never mutated.
{% macro apache(name, entry, context={}) %}
/etc/apache2/sites-available/{{ name }}.conf.include:
  file.managed:
    - source: salt://apache/files/sites/{{ entry.configuration }}.conf.include
    - template: jinja
    - context: {{ dict(context, name=name, **entry.get('context', {}))|yaml }}
    - require:
      - pkg: apache2
    - watch_in:
      - module: apache2-reload

/etc/apache2/sites-available/{{ name }}.conf:
  file.managed:
    - source: salt://apache/files/sites/_common.conf
    - template: jinja
    - context:
        includefile: /etc/apache2/sites-available/{{ name }}.conf.include
        servername: {{ entry.servername }}
        serveraliases: {{ entry.get('serveraliases', [])|yaml }}
        https: {{ entry.get('https', True) }}
    - require:
      - file: /etc/apache2/sites-available/{{ name }}.conf.include
    - watch_in:
      - module: apache2-reload

enable-{{ name }}-site:
  apache_site.enabled:
    - name: {{ name }}
    - require:
      - file: /etc/apache2/sites-available/{{ name }}.conf
    - watch_in:
      - module: apache2-reload

{% if 'htpasswd' in entry %}
add-{{ name }}-htpasswd:
  webutil.user_exists:
    - name: {{ entry.htpasswd.name }}
    - password: {{ entry.htpasswd.password }}
    - htpasswd_file: /etc/apache2/.htpasswd-{{ name }}
    - update: True
    - require:
      - pkg: apache2
{% endif %}
{% endmacro %}
