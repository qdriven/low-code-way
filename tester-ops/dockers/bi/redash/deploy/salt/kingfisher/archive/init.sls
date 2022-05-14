include:
  - kingfisher.collect
  - python_apps

{% set entry = pillar.python_apps.kingfisher_archive %}
{% set userdir = '/home/' + entry.user %}
{% set directory = userdir + '/' + entry.git.target %}

kingfisher-archive-prerequisites:
  pkg.installed:
    - pkgs:
      - sqlite3

{{ directory }}/.env:
  file.managed:
    - source: salt://kingfisher/archive/files/.env
    - template: jinja
    - context:
        userdir: {{ userdir }}
        scrapyd_dir: {{ userdir }}/scrapyd
    - user: {{ entry.user }}
    - group: {{ entry.user }}
    - mode: 400
    - require:
      - git: {{ entry.git.url }}

#cd {{ directory }}; . .ve/bin/activate; python manage.py archive:
#  cron.present:
#    - identifier: OCDS_KINGFISHER_ARCHIVE_RUN
#    - user: {{ entry.user }}
#    - minute: 0
#    - hour: 1
#    - dayweek: 6
