Maintain PostgreSQL
===================

Troubleshoot
------------

Check the log file, ``/var/log/postgresql/postgresql-11-main.log``, if debugging an unscheduled restart of the ``postgres`` service, for example.

Control access
--------------

Each individual should have a personal account, and each service should have a service account.

Add a user
~~~~~~~~~~

#. Add, in a private Pillar file, replacing ``PASSWORD`` with a `strong password <https://www.lastpass.com/password-generator>`__ and ``USERNAME`` with a recognizable username (for example, the lowercase first initial and family name of the person, like ``jdoe``):

   .. code-block:: yaml

      postgres:
        users:
          # me@example.com
          USERNAME:
            password: "PASSWORD"

#. Assign the user to groups. For example, the ``kingfisher-process`` target has the groups:

   kingfisher_process_read
     ``SELECT`` on all tables in schema ``public``
   kingfisher_summarize_read
     ``SELECT`` on all tables in schema created by Kingfisher Summarize

   .. code-block:: yaml
      :emphasize-lines: 6-8

      postgres:
        users:
          # me@example.com
          USERNAME:
            password: "PASSWORD"
            groups:
              - kingfisher_process_read
              - kingfisher_summarize_read

#. :doc:`Deploy the service<../deploy/deploy>`

Update password
~~~~~~~~~~~~~~~

#. Update the private Pillar file, for example:

   .. code-block:: yaml
      :emphasize-lines: 5

      postgres:
        users:
          # me@example.com
          USERNAME:
            password: "PASSWORD"

#. :doc:`Deploy the service<../deploy/deploy>`

#. Notify the contact at the email address in the comment

Delete a user
~~~~~~~~~~~~~

#. Delete the user from the private Pillar file

#. Connect to the server as the ``root`` user, for example:

   .. code-block:: bash

      curl --silent --connect-timeout 1 process.kingfisher.open-contracting.org:8255 || true
      ssh root@process.kingfisher.open-contracting.org

#. Attempt to drop the user as the ``postgres`` user, for example:

   .. code-block:: bash

      su - postgres -c 'psql ocdskingfisherprocess -c "DROP ROLE ocdskfpguest;"'

#. If you see a message like:

   .. code-block:: none

      ERROR:  role "ocdskfpguest" cannot be dropped because some objects depend on it
      DETAIL:  privileges for table …
      …
      and 1234 other objects (see server log for list)

#. Open the server log, and search for the relevant ``DROP ROLE`` statement (after running the command below, press ``/``, type ``DROP ROLE``, press Enter, and press ``n`` until you match the relevant statement):

   .. code-block:: bash

      less /var/log/postgresql/postgresql-11-main.log

#. If all the objects listed after ``DETAIL:`` in the server log can be dropped (press Space to scroll forward), then press ``q`` to quit ``less`` and open a SQL terminal as the ``postgres`` user:

   .. code-block:: bash

      su - postgres -c 'psql ocdskingfisherprocess'

#. Finally, drop the user:

   .. code-block:: sql

      REASSIGN OWNED BY ocdskfpguest TO anotheruser;
      DROP OWNED BY ocdskfpguest;
      DROP ROLE ocdskfpguest;

Check privileges
~~~~~~~~~~~~~~~~

List users and groups:

.. code-block:: none

   \du

Find unexpected database ``CREATE`` privileges:

.. code-block:: sql

   SELECT usename, string_agg(datname, ', ' ORDER BY datname)
   FROM pg_user
   CROSS JOIN pg_database
   WHERE
       usename NOT IN ('postgres') AND
       has_database_privilege(usename, datname, 'CREATE') AND
       NOT (usename = 'kingfisher_summarize' AND datname = 'ocdskingfisherprocess')
   GROUP BY usename
   ORDER BY usename;

Find unexpected schema ``CREATE`` privileges:

.. code-block:: sql

   SELECT usename, string_agg(nspname, ', ' ORDER BY nspname)
   FROM pg_user
   CROSS JOIN pg_namespace
   WHERE
       usename NOT IN ('postgres') AND
       has_schema_privilege(usename, nspname, 'CREATE') AND
       NOT (usename = 'kingfisher_process' AND nspname = 'public') AND
       NOT (usename = 'kingfisher_summarize' AND nspname LIKE 'view_data_%')
   GROUP BY usename
   ORDER BY usename;

Find unexpected schema ``USAGE`` privileges:

.. code-block:: sql

   SELECT usename, string_agg(nspname, ', ' ORDER BY nspname)
   FROM pg_user
   CROSS JOIN pg_namespace
   WHERE
       usename NOT IN ('postgres') AND
       nspname NOT IN ('information_schema', 'pg_catalog', 'reference') AND
       has_schema_privilege(usename, nspname, 'USAGE') AND
       NOT (usename = 'kingfisher_summarize' AND nspname LIKE 'view_data_%') AND
       NOT (pg_has_role(usename, 'kingfisher_process_read', 'MEMBER') AND nspname = 'public') AND
       NOT (pg_has_role(usename, 'kingfisher_summarize_read', 'MEMBER') AND nspname LIKE 'view_data_%')
   GROUP BY usename
   ORDER BY usename;

Find unexpected table non ``SELECT`` privileges:

.. code-block:: sql

   SELECT usename, nspname, string_agg(relname, ', ' ORDER BY relname)
   FROM pg_user
   CROSS JOIN pg_class c
   JOIN pg_namespace n ON c.relnamespace = n.oid
   WHERE
       usename NOT IN ('postgres') AND
       nspname NOT IN ('pg_toast') AND
       relname NOT IN ('pg_settings') AND
       has_table_privilege(usename, c.oid, 'INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER') AND
       NOT (usename = 'kingfisher_process' AND nspname = 'public') AND
       NOT (usename = 'kingfisher_summarize' AND nspname LIKE 'view_data_%')
   GROUP BY usename, nspname
   ORDER BY usename, nspname;

Reference: `System Information Functions <https://www.postgresql.org/docs/current/functions-info.html>`__ for functions like ``has_schema_privilege``

Improve performance
-------------------

Tune settings
~~~~~~~~~~~~~

-  :doc:`Connect to the server<../use/ssh>`
-  Change to the ``postgres`` user:

   .. code-block:: bash

      su - postgres

-  Download the ``postgresqltuner.sql`` file (if not available):

   .. code-block:: bash

      curl -O https://raw.githubusercontent.com/jfcoz/postgresqltuner/master/postgresqltuner.pl

-  Make the ``postgresqltuner.sql`` file executable:

   .. code-block:: bash

      chmod ug+x postgresqltuner.pl

-  Run the ``postgresqltuner.sql`` file:

   .. code-block:: bash

      ./postgresqltuner.sql --ssd

Under "Configuration advice", address "HIGH" and "MEDIUM" recommendations.

Reference: `Tuning Your PostgreSQL Server <https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server>`__

Reference: `Slow Query Questions <https://wiki.postgresql.org/wiki/Slow_Query_Questions>`__

.. _pg-stat-all-tables:

Check autovacuum statistics
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: sql

   SELECT
       nspname,
       s.relname,
       reltuples,
       n_live_tup::real,
       n_dead_tup::real,
       TRUNC(n_dead_tup / GREATEST(reltuples::numeric, 1) * 100, 2) AS percent,
       last_autovacuum,
       last_autoanalyze
   FROM pg_stat_all_tables s
   JOIN pg_class c ON relid = c.oid
   JOIN pg_namespace ON relnamespace = pg_namespace.oid
   ORDER BY percent DESC, last_autovacuum;

See the `pg_stat_all_tables <https://www.postgresql.org/docs/11/monitoring-stats.html#PG-STAT-ALL-TABLES-VIEW>`__ table's documentation.

To get the table related to a ``pg_toast_*`` table, take the number after ``pg_toast_``, and run, for example:

.. code-block:: sql

   SELECT '16712'::regclass;

Check usage
-----------

Explore database
~~~~~~~~~~~~~~~~

List databases:

.. code-block:: none

   \l

List schemas:

.. code-block:: none

   \dn

List tables, views and sequences in the ``public`` schema:

.. code-block:: none

   \d

List tables, indexes, views and sequences in the ``public`` schema:

.. code-block:: none

   \dtivs

To list tables, views and/or sequences in a specific schema, append, for example, ``views.*`` – or append ``*.*`` for all schema.

You can use the ``psql`` command's ``-E`` (``--echo-hidden``) `flag <https://www.postgresql.org/docs/11/app-psql.html#R1-APP-PSQL-3>`__ to echo the queries generated by the backslash commands.

Check disk usage
~~~~~~~~~~~~~~~~

Get all database sizes:

.. code-block:: none

   \l+

Get all schema sizes:

.. code-block:: sql

   SELECT
       schema_name,
       schema_size,
       pg_size_pretty(schema_size),
       TRUNC(schema_size::numeric / pg_database_size(current_database()) * 100, 2) AS percent
   FROM (
       SELECT
           nspname AS schema_name,
           SUM(pg_relation_size(c.oid))::bigint AS schema_size
       FROM pg_class c
       JOIN pg_namespace n ON c.relnamespace = n.oid
       GROUP BY schema_name
   ) t
   ORDER BY schema_size DESC;

Get relation sizes in the ``public`` schema:

.. code-block:: none

   \dtis+

To get relation sizes in a specific schema, append, for example, ``views.*`` – or append ``*.*`` for all schema.

See the `Database Object Size Functions <https://www.postgresql.org/docs/11/functions-admin.html#FUNCTIONS-ADMIN-DBSIZE>`__ documentation.

.. _pg-stat-activity:

Show running queries
~~~~~~~~~~~~~~~~~~~~

Show running queries:

.. code-block:: sql

   SELECT pid, client_addr, usename, state, wait_event_type, NOW() - query_start AS time, query
   FROM pg_stat_activity
   WHERE query <> ''
   ORDER BY time DESC;

See the `pg_stat_activity <https://www.postgresql.org/docs/11/monitoring-stats.html#PG-STAT-ACTIVITY-VIEW>`__ table's documentation.

.. _pg-recover-replica:

Recover the replica
-------------------

If replication breaks or the replica server goes offline, you must recover the replica, in two stages: mitigate the downtime, and fix the replication.

Mitigate downtime
~~~~~~~~~~~~~~~~~

#. :ref:`Enable public access<postgres-public-access>` to the PostgreSQL service on the main server, by modifying its Pillar file:

   .. code-block:: yaml

      postgres:
        public_access: True

   For example, for the ``kingfisher-process`` target, modify the ``pillar/kingfisher.sls`` file.

#. :doc:`Deploy the main server<../../deploy/deploy>`
#. Update DNS records:

   #. Login to `GoDaddy <https://sso.godaddy.com>`__
   #. If access was delegated, open `Delegate Access <https://account.godaddy.com/access>`__ and click the *Access Now* button
   #. Open `DNS Management <https://dcc.godaddy.com/manage/OPEN-CONTRACTING.ORG/dns>`__ for open-contracting.org
   #. Update the replica's CNAME record to point to the main server's A record: for example, point ``postgres-readonly`` to ``kingfisher-process1``
   #. Wait for the changes to propagate, which depends on the original TTL value

Fix replication
~~~~~~~~~~~~~~~

#. Copy WAL archives from the main server to the replica server, replacing ``example.open-contracting.org`` below with the main server's hostname:

   .. note::

      The ``postgres`` user on the replica server must have an SSH key pair, and its public key must be an authorized key of the ``postgres`` user on the main server. See :ref:`pg-ssh-key-setup`.

   .. code-block:: bash

      service postgres stop
      sudo su - postgres
      timeout 1 ssh postgres@example.open-contracting.org -p 8255
      rsync -azv postgres@example.open-contracting.org:/var/lib/postgresql/11/main/archive/ /var/lib/postgresql/11/main/archive/
      exit
      service postgres start

#. Monitor the replica logs. You should see messages about recovery from WAL files.

   .. code-block:: bash

      tail -f /var/log/postgresql/postgresql-11-main.log

If all else fails, you can fallback to rebuilding the replica. See :ref:`pg-setup-replication`.
