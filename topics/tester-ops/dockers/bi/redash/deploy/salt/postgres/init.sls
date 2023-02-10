{% from 'lib.sls' import set_firewall, unset_firewall %}

{% set pg_version = pillar.postgres.get('version', '11') %}

{% if pillar.postgres.get('public_access') %}
  {{ set_firewall("PUBLIC_POSTGRESQL") }}
  {{ unset_firewall("PRIVATE_POSTGRESQL") }}
  {{ unset_firewall("REPLICA_IPV4") }}
  {{ unset_firewall("REPLICA_IPV6") }}
{% else %}
  {{ unset_firewall("PUBLIC_POSTGRESQL") }}
  {{ set_firewall("PRIVATE_POSTGRESQL") }}
  {% if pillar.postgres.get('replica_ipv4') %}
    {{ set_firewall("REPLICA_IPV4", pillar.postgres.replica_ipv4|join(' ')) }}
  {% endif %}
  {% if pillar.postgres.get('replica_ipv6') %}
    {{ set_firewall("REPLICA_IPV6", pillar.postgres.replica_ipv6|join(' ')) }}
  {% endif %}
  {% if salt['pillar.get']('maintenance:enabled') %}
    {{ set_firewall("MONITOR_APPBEAT") }}
  {% endif %}
{% endif %}

postgresql:
  pkgrepo.managed:
    - humanname: PostgreSQL Official Repository
    - name: deb https://apt.postgresql.org/pub/repos/apt {{ grains.oscodename }}-pgdg main
    - dist: {{ grains.oscodename }}-pgdg
    - file: /etc/apt/sources.list.d/psql.list
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
  pkg.installed:
    - name: postgresql-{{ pg_version }}
    - require:
      - pkgrepo: postgresql
  service.running:
    # The service called "postgresql" is a dummy service for this
    - name: postgresql@{{ pg_version }}-main.service
    - enable: True
    - require:
      - pkg: postgresql

postgresql-reload:
  module.wait:
    - name: service.reload
    - m_name: postgresql@{{ pg_version }}-main.service

# Upload access configuration for postgres.
/etc/postgresql/{{ pg_version }}/main/pg_hba.conf:
  file.managed:
    - source: salt://postgres/files/pg_hba.conf
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 640
    - watch_in:
      - module: postgresql-reload

# Upload custom configuration if defined.
{% if pillar.postgres.configuration %}
/etc/postgresql/{{ pg_version }}/main/conf.d/030_{{ pillar.postgres.configuration }}.conf:
  file.managed:
    - source: salt://postgres/files/conf/{{ pillar.postgres.configuration }}.conf
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 640
    - watch_in:
      - service: postgresql
{% endif %}

# https://www.postgresql.org/docs/11/kernel-resources.html#LINUX-MEMORY-OVERCOMMIT
# https://github.com/jfcoz/postgresqltuner
vm.overcommit_memory:
  sysctl.present:
    - value: {{ salt['pillar.get']('vm:overcommit_memory', 2) }}

# https://www.postgresql.org/docs/11/kernel-resources.html#LINUX-HUGE-PAGES
# https://github.com/jfcoz/postgresqltuner
{% if salt['pillar.get']('vm:nr_hugepages') %}
vm.nr_hugepages:
  sysctl.present:
    - value: {{ pillar.vm.nr_hugepages }}
{% endif %}

# https://github.com/jfcoz/postgresqltuner
pg_stat_statements:
  postgres_extension.present:
    - maintenance_db: template1
    - if_not_exists: True

{% if salt['pillar.get']('postgres:ssh_key') %}
/var/lib/postgresql/.ssh:
  file.directory:
    - makedirs: True
    - mode: 700

/var/lib/postgresql/.ssh/id_rsa:
  file.managed:
    - contents_pillar: postgres:ssh_key
    - mode: 600
{% endif %}

{% if salt['pillar.get']('postgres:users') %}
{% for name, entry in pillar.postgres.users.items() %}
sql-user-{{ name }}:
  postgres_user.present:
    - name: {{ name }}
{% if 'password' in entry %}
    - password: "{{ entry.password }}"
{% endif %}
{% if 'groups' in entry %}
    - groups: {{ entry.groups|yaml }}
{% endif %}
{% if entry.get('replication') %}
    - replication: True
{% endif %}
    - require:
      - service: postgresql
{% if 'groups' in entry %}
{% for group in entry.groups %}
      - postgres_group: {{ group }}
{% endfor %}
{% endif %}
{% endfor %}
{% endif %}
