{% from 'lib.sls' import create_user, systemd %}

{% set user = 'ocdskfs' %}
{% set userdir = '/home/' + user %}
{% set directory = userdir + '/scrapyd' %}

{{ create_user(user) }}

{{ directory }}:
  file.directory:
    - names:
      - {{ directory }}/dbs
      - {{ directory }}/eggs
      - {{ directory }}/logs
    - makedirs: True
    - user: {{ user }}
    - group: {{ user }}

{{ directory }}/requirements.txt:
  file.managed:
    - source: https://raw.githubusercontent.com/open-contracting/kingfisher-collect/main/requirements.txt
    - source_hash: https://raw.githubusercontent.com/open-contracting/kingfisher-collect/main/requirements.txt.sha256
    - user: {{ user }}
    - group: {{ user }}
    - mode: 444
    - require:
      - file: {{ directory }}

# The next states are similar to those in the `python_apps.sls` file, but instead of being based on a git repository,
# they are based on a requirements.txt file.

{{ directory }}/.ve:
  pkg.installed:
    - pkgs:
      - python3-virtualenv # the library
      - virtualenv # the executable
  virtualenv.managed:
    - python: /usr/bin/python3
    - user: {{ user }}
    - system_site_packages: False
    - pip_pkgs:
      - pip-tools
    - require:
      - pkg: virtualenv
      - file: {{ directory }}

{{ directory }}-requirements:
  cmd.run:
    - name: . .ve/bin/activate; pip-sync -q --pip-args "--exists-action w"
    - runas: {{ user }}
    - cwd: {{ directory }}
    - require:
      - virtualenv: {{ directory }}/.ve
    - onchanges:
      - file: {{ directory }}/requirements.txt
      - virtualenv: {{ directory }}/.ve # if .ve was deleted
    - watch_in:
      - service: scrapyd

# https://scrapyd.readthedocs.io/en/stable/config.html
{{ userdir }}/.scrapyd.conf:
  file.managed:
    - source: salt://kingfisher/collect/files/scrapyd.ini
    - template: jinja
    - context:
        appdir: {{ directory }}
    - watch_in:
      - service: scrapyd

/var/log/scrapyd:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True
    - require_in:
      - service: scrapyd

{{ systemd({'service': 'scrapyd', 'user': user, 'appdir': directory}) }}

find {{ userdir }}/scrapyd/logs/ -type f -name "*.log" -exec sh -c 'if [ ! -f {}.stats ]; then result=$(tac {} | head -n99 | grep -m1 -B99 statscollectors | tac); if [ ! -z "$result" ]; then echo "$result" > {}.stats; fi; fi' \;:
  cron.present:
    - identifier: OCDS_KINGFISHER_SCRAPE_LOG_STATS
    - user: {{ user }}
    - minute: 0
