{% from 'lib.sls' import create_user, set_firewall %}

include:
  - python_apps
  - react_apps

{{ set_firewall("PUBLIC_SSH") }}

{% set frontend_entry = pillar.react_apps.covid19public %}
{% set backend_entry = pillar.python_apps.covid19admin %}

{{ create_user(frontend_entry.user, authorized_keys=pillar.ssh.covid19) }}
{{ create_user(backend_entry.user, authorized_keys=pillar.ssh.covid19admin) }}
