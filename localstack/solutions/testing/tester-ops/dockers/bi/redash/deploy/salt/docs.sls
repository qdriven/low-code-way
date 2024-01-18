{% from 'lib.sls' import create_user %}

include:
  - apache
  - apache.modules.rewrite

{% set user = 'ocds-docs' %}
{{ create_user(user, authorized_keys=pillar.ssh.docs) }}

# Needed to create a ZIP file of the schema and codelists.
# https://ocdsdeploy.readthedocs.io/en/latest/deploy/docs.html#copy-the-schema-and-zip-file-into-place
zip:
  pkg.installed

docs modules:
  apache_module.enabled:
    - names:
      - headers
      - include
      - substitute
    - watch_in:
      - service: apache2

/var/www/html/robots.txt:
  file.managed:
    - source: salt://apache/files/docs/robots_disallow.txt
    - require:
      - pkg: apache2

/home/{{ user }}/web:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True
    - require:
      - user: {{ user }}_user_exists

/home/{{ user }}/web/robots.txt:
  file.managed:
    - source: salt://apache/files/docs/robots.txt
    - user: {{ user }}
    - group: {{ user }}
    - require:
      - file: /home/{{ user }}/web

/home/{{ user }}/web/includes:
  file.recurse:
    - source: salt://apache/files/docs/includes
    - user: {{ user }}
    - group: {{ user }}
    - require:
      - file: /home/{{ user }}/web

/home/{{ user}}/1-size.sh:
  file.managed:
    - source: salt://files/docs-size.sh
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700

/home/{{ user}}/2-delete.sh:
  file.managed:
    - source: salt://files/docs-delete.sh
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700

# These will be served the same as files that were copied into place.
https://github.com/open-contracting/standard-legacy-staticsites.git:
  git.latest:
    - user: {{ user }}
    - force_fetch: True
    - force_reset: True
    - branch: master
    - rev: master
    - target: /home/{{ user }}/web/legacy/
    - require:
      - pkg: git
      - file: /home/{{ user }}/web

# This sets up redirects and an archived opendatacomparison static site for ocds.open-contracting.org,
# which has been replaced by standard.open-contracting.org

{% set legacy = 'opencontracting' %}
{{ create_user(legacy) }}

https://github.com/open-contracting/opendatacomparison-archive.git:
  git.latest:
    - user: {{ legacy }}
    - force_fetch: True
    - force_reset: True
    - branch: live
    - rev: live
    - target: /home/{{ legacy }}/opendatacomparison-archive/
    - require:
      - pkg: git
      - user: {{ legacy }}_user_exists
