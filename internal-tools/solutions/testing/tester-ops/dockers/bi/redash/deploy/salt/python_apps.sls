{% from 'lib.sls' import apache %}

# So far, all servers with Python apps use Apache and uWSGI. If we later have a server that doesn't need these, we can
# add boolean key to the Pillar data to indicate whether to include these.
include:
  - uwsgi
  - apache
  - apache.modules.proxy_http
  - apache.modules.proxy_uwsgi

virtualenv:
  pkg.installed:
    - pkgs:
      - python3-virtualenv # the library
      - virtualenv # the executable

# Inspired by the Apache formula, which loops over sites to configure. See example in readme.
# https://github.com/saltstack-formulas/apache-formula
# https://github.com/saltstack-formulas/apache-formula/blob/master/apache/config/register_site.sls
{% for name, entry in pillar.python_apps.items() %}

# A user might run multiple apps, so the user is not created here.
{% set userdir = '/home/' + entry.user %}
{% set directory = userdir + '/' + entry.git.target %}
{% set context = {'name': name, 'entry': entry, 'appdir': directory} %}

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

{{ directory }}/.ve:
  virtualenv.managed:
    - python: /usr/bin/python3
    - user: {{ entry.user }}
    - system_site_packages: False
    - pip_pkgs:
      - pip-tools
    - require:
      - pkg: virtualenv
      - git: {{ entry.git.url }}

{{ directory }}-requirements:
  cmd.run:
    - name: . .ve/bin/activate; pip-sync -q --pip-args "--exists-action w"
    - runas: {{ entry.user }}
    - cwd: {{ directory }}
    - require:
      - virtualenv: {{ directory }}/.ve
    # Note: This will run if git changed (not only if requirements changed), and uwsgi will be reloaded.
    - onchanges:
      - git: {{ entry.git.url }}
      - virtualenv: {{ directory }}/.ve # if .ve was deleted
    # https://github.com/open-contracting/deploy/issues/146
    - watch_in:
      - service: uwsgi

{% if 'config' in entry %}
{% for filename, source in entry.config.items() %}
{{ userdir }}/.config/{{ filename }}:
  file.managed:
    - source: {{ source }}
    - template: jinja
    - user: {{ entry.user }}
    - group: {{ entry.user }}
    - makedirs: True
    - require:
      - user: {{ entry.user }}_user_exists
{% endfor %}
{% endif %}{# config #}

{% if 'django' in entry %}
{{ directory }}-migrate:
  cmd.run:
    - name: . .ve/bin/activate; DJANGO_SETTINGS_MODULE={{ entry.django.app }}.settings python manage.py migrate --noinput
    - runas: {{ entry.user }}
    - env: {{ entry.django.env|yaml }}
    - cwd: {{ directory }}
    - require:
      - cmd: {{ directory }}-requirements
    - onchanges:
      - git: {{ entry.git.url }}

{{ directory }}-collectstatic:
  cmd.run:
    - name: . .ve/bin/activate; DJANGO_SETTINGS_MODULE={{ entry.django.app }}.settings python manage.py collectstatic --noinput
    - runas: {{ entry.user }}
    - env: {{ entry.django.env|yaml }}
    - cwd: {{ directory }}
    - require:
      - cmd: {{ directory }}-requirements
    - onchanges:
      - git: {{ entry.git.url }}

{% if salt['pillar.get']('custom_command:script') %}
django-custom-command:
  cmd.run:
    - name: . .ve/bin/activate; DJANGO_SETTINGS_MODULE={{ entry.django.app }}.settings python {{ salt['pillar.get']('custom_command:script') }}
    - runas: {{ entry.user }}
    - env: {{ entry.django.env|yaml }}
    - cwd: {{ directory }}
{% endif %}

{% if 'compilemessages' in entry.django %}
{{ directory }}-compilemessages:
  pkg.installed:
    - name: gettext
  cmd.run:
    - name: . .ve/bin/activate; DJANGO_SETTINGS_MODULE={{ entry.django.app }}.settings python manage.py compilemessages
    - runas: {{ entry.user }}
    - env: {{ entry.django.env|yaml }}
    - cwd: {{ directory }}
    - output_loglevel: warning
    - require:
      - cmd: {{ directory }}-requirements
    - onchanges:
      - git: {{ entry.git.url }}
{% endif %}
{% endif %}{# django #}

{% if 'uwsgi' in entry %}
/etc/uwsgi/apps-available/{{ entry.git.target }}.ini:
  file.managed:
    - source: salt://uwsgi/files/{{ entry.uwsgi.configuration }}.ini
    - template: jinja
    - context: {{ context|yaml }}
    - makedirs: True
    - watch_in:
      - service: uwsgi

/etc/uwsgi/apps-enabled/{{ entry.git.target }}.ini:
  file.symlink:
    - target: /etc/uwsgi/apps-available/{{ entry.git.target }}.ini
    - makedirs: True
    - require:
      - file: /etc/uwsgi/apps-available/{{ entry.git.target }}.ini
    - watch_in:
      - service: uwsgi
{% endif %}{# uwsgi #}

{% if 'apache' in entry %}
{{ apache(entry.git.target, entry.apache, context=context) }}
{% endif %}{# apache #}

{% endfor %}
