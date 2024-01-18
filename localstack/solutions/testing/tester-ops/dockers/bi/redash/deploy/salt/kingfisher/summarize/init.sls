include:
  - kingfisher.process
  - python_apps

{% set entry = pillar.python_apps.kingfisher_summarize %}
{% set userdir = '/home/' + entry.user %}
{% set directory = userdir + '/' + entry.git.target %}

{{ directory }}/.env:
  file.managed:
    - source: salt://kingfisher/summarize/files/.env
    - user: {{ entry.user }}
    - group: {{ entry.user }}
    - mode: 400
    - require:
      - git: {{ entry.git.url }}
