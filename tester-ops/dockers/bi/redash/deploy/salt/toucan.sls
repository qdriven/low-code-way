{% from 'lib.sls' import create_user %}

include:
  - python_apps

{% set entry = pillar.python_apps.toucan %}
{% set userdir = '/home/' + entry.user %}
{% set directory = userdir + '/' + entry.git.target %}

{{ create_user(entry.user) }}

toucan-deps:
  pkg.installed:
    - name: libyajl-dev # OCDS Kit performance

{{ directory }}/googleapi_credentials.json:
  file.managed:
    - source: salt://files/googleapi_credentials.json
    - template: jinja
    - user: {{ entry.user }}
    - group: {{ entry.user }}
    - mode: 600
    - require:
      - git: {{ entry.git.url }}

find {{ directory }}/media -mindepth 2 -mtime +1 -delete:
  cron.present:
    - identifier: OCDS_TOUCAN_CLEAR_MEDIA_1
    - user: {{ entry.user }}
    - minute: 0
    - hour: 0

find {{ directory }}/media -mindepth 1 -type d -empty -delete:
  cron.present:
    - identifier: OCDS_TOUCAN_CLEAR_MEDIA_2
    - user: {{ entry.user }}
    - minute: 0
    - hour: 0
