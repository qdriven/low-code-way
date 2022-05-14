{% from 'lib.sls' import create_user %}

include:
  - apache.modules.remoteip
  - python_apps

{% set entry = pillar.python_apps.cove %}
{% set userdir = '/home/' + entry.user %}
{% set directory = userdir + '/' + entry.git.target %}

{{ create_user(entry.user) }}

cd {{ directory }}; . .ve/bin/activate; DJANGO_SETTINGS_MODULE={{ entry.django.app }}.settings SECRET_KEY="{{ entry.django.env.SECRET_KEY|replace('%', '\%') }}" python manage.py expire_files:
  cron.present:
    - identifier: COVE_EXPIRE_FILES
    - user: {{ entry.user }}
    - minute: random
    - hour: 0

MAILTO:
  cron.env_present:
    - name: MAILTO
    - value: sysadmin@open-contracting.org
    - user: {{ entry.user }}
