# Groups
# https://wiki.postgresql.org/images/d/d1/Managing_rights_in_postgresql.pdf

{% set groups = ['reference', 'kingfisher_process_read', 'kingfisher_summarize_read'] %}

{% for group in groups %}
{{ group }}:
  postgres_group.present:
    - name: {{ group }}
    - require:
      - service: postgresql
{% endfor %}

# Databases

ocdskingfisherprocess:
  postgres_database.present:
    - name: ocdskingfisherprocess
    - owner: postgres
    - require:
      - service: postgresql

# Extensions

# https://github.com/open-contracting/deploy/issues/117
# https://github.com/open-contracting/deploy/issues/237
{% set extensions = ['tablefunc', 'fuzzystrmatch', 'pg_trgm'] %}

{% for extension in extensions %}
{{ extension }}:
  postgres_extension.present:
    - name: {{ extension }}
    - if_not_exists: True
    - maintenance_db: ocdskingfisherprocess
    - require:
      - postgres_database: ocdskingfisherprocess
{% endfor %}

# Schemas

create reference schema:
  postgres_schema.present:
    - name: reference
    - owner: reference
    - dbname: ocdskingfisherprocess
    - require:
      - postgres_group: reference
      - postgres_database: ocdskingfisherprocess

# REVOKE privileges
# https://www.postgresql.org/docs/11/sql-revoke.html

revoke public schema privileges:
  postgres_privileges.absent:
    - name: public
    - privileges:
      - ALL
    - object_type: schema
    - object_name: public
    - maintenance_db: ocdskingfisherprocess
    - require:
      - postgres_database: ocdskingfisherprocess

# GRANT privileges
# https://www.postgresql.org/docs/11/sql-grant.html
# https://www.postgresql.org/docs/11/ddl-priv.html

# https://kingfisher-process.readthedocs.io/en/latest/requirements-install.html#database
grant kingfisher_process schema privileges:
  postgres_privileges.present:
    - name: kingfisher_process
    - privileges:
      - ALL
    - object_type: schema
    - object_name: public
    - maintenance_db: ocdskingfisherprocess
    - require:
      - postgres_user: sql-user-kingfisher_process
      - postgres_database: ocdskingfisherprocess

# "The database user must have the CREATE privilege on the database used by Kingfisher Process."
# https://kingfisher-summarize.readthedocs.io/en/latest/get-started.html#database
grant kingfisher_summarize database privileges:
  postgres_privileges.present:
    - name: kingfisher_summarize
    - privileges:
      - CREATE
    - object_type: database
    - object_name: ocdskingfisherprocess
    - maintenance_db: ocdskingfisherprocess
    - require:
      - postgres_user: sql-user-kingfisher_summarize
      - postgres_database: ocdskingfisherprocess

# Kingfisher Summarize grants access to view_data_* schemas to the kingfisher_summarize_read group.
{% set schema_groups = {'reference': ['public'], 'public': ['kingfisher_process_read']} %}

{% for schema, groups in schema_groups.items() %}
{% for group in groups %}
grant {{ group }} schema privileges in {{ schema }}:
  postgres_privileges.present:
    - name: {{ group }}
    - privileges:
      - USAGE
    - object_type: schema
    - object_name: {{ schema }}
    - maintenance_db: ocdskingfisherprocess
    - require:
      - postgres_database: ocdskingfisherprocess

grant {{ group }} table privileges in {{ schema }}:
  postgres_privileges.present:
    - name: {{ group }}
    - privileges:
      - SELECT
    - object_type: table
    - object_name: ALL
    - prepend: {{ schema }}
    - maintenance_db: ocdskingfisherprocess
    - require:
      - postgres_database: ocdskingfisherprocess

/opt/{{ group }}-{{ schema }}.sql:
  file.managed:
    - name: /opt/{{ group }}-{{ schema }}.sql
    - contents: "ALTER DEFAULT PRIVILEGES FOR ROLE kingfisher_process IN SCHEMA {{ schema }} GRANT SELECT ON TABLES TO {{ group }};"

# Can replace after `postgres_default_privileges` function becomes available.
# https://github.com/saltstack/salt/pull/56808
alter {{ group }} default privileges in {{ schema }}:
  cmd.run:
    - name: psql -f /opt/{{ group }}-{{ schema }}.sql ocdskingfisherprocess
    - runas: postgres
    - onchanges:
      - file: /opt/{{ group }}-{{ schema }}.sql
    - require:
      - postgres_database: ocdskingfisherprocess
{% endfor %}
{% endfor %}
