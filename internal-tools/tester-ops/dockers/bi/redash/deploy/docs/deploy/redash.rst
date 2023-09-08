Redash tasks
============

Create a Redash server
----------------------

First, :doc:`create the new server<create_server>`, making sure to use the ``redash`` state file.

Update script
~~~~~~~~~~~~~

We `installed Redash <https://redash.io/help/open-source/setup#docker>`__ using its `setup script <https://github.com/getredash/setup>`__. However, we made a few changes to its ``setup.sh`` file:

#. Add a comment with a link to the version used of the setup script (to make it easier to compare against future scripts).
#. Comment out the ``install_docker`` function call. (The ``docker`` state file installs Docker, to keep system packages under Salt's management.)
#. Change the ``nginx`` service's `ports <https://docs.docker.com/compose/compose-file/#ports>`__ to ``9090:80`` instead of ``80:80``. (Apache uses port 80 to serve requests to the :doc:`Prometheus client<prometheus>`, so the port isn't available for Nginx. To serve requests to Redash, Apache proxies requests on port 80 to port 9090.)
#. Expose the ``postgres`` service's ports as ``5432:5432`` (to make it easier to load a database dump).
#. Comment out the database creation and container startup commands (to be run after upgrade).

Before :ref:`running the script<run-redash-script>`, compare the ``setup-redash.sh`` file in this repository to the latest version of the `setup script <https://github.com/getredash/setup>`__.

.. _run-redash-script:

Run script
~~~~~~~~~~

#. If migrating from an old server, get its configuration settings and database dump.

   #. Connect to the old server. For example:

      .. code-block:: bash

         curl --silent --connect-timeout 1 redash.open-contracting.org:8255 || true
         ssh root@redash.open-contracting.org

   #. Copy the values of the ``REDASH_COOKIE_SECRET`` and ``REDASH_SECRET_KEY`` variables in the ``/opt/redash/env`` file on the old server:

      .. code-block:: bash

         cat /opt/redash/env

   #. Dump the database. You might need to expose ports for the ``postgres`` service.

      .. code-block:: bash

         pg_dump -h localhost -U postgres postgres -f redash.sql

   #. Disconnect from the old server:

      .. code-block:: bash

         exit

   #. Copy the database dump to your local machine. For example:

      .. code-block:: bash

         scp root@redash.open-contracting.org:~/redash.sql .

   #. Copy the database dump to the new server. For example:

      .. code-block:: bash

         scp redash.sql root@HOSTNAME:~/

   #. Edit the ``setup-redash.sh`` file in this repository, setting the ``COOKIE_SECRET`` and ``SECRET_KEY`` variables to the values copied above.

#. Copy the ``setup-redash.sh`` file in this repository to the new server. For example:

   .. code-block:: bash

      scp setup-redash.sh root@HOSTNAME:~/

#. Connect to the new server. For example:

   .. code-block:: bash

      ssh root@HOSTNAME

#. Run the ``setup-redash.sh`` file:

   .. code-block:: bash

      bash setup-redash.sh

#. If migrating from an old server, restore the database dump and upgrade the database.

   #. Get the PostgreSQL credentials on the new server:

      .. code-block:: bash

         grep REDASH_DATABASE_URL /opt/redash/env

   #. Start the ``postgres`` service:

      .. code-block:: bash

         docker-compose up -d postgres

   #. Load the database dump using the PostgreSQL credentials:

      .. code-block:: bash

         psql -h localhost -U postgres postgres -f redash.sql

   #. Apply database migrations (starts services as needed):

      .. code-block:: bash

         docker-compose run --rm server manage db upgrade

#. If creating a new server from scratch, create the database:

   .. code-block:: bash

      docker-compose run --rm server create_db

#. Remove the ``ports`` variable from the ``/opt/redash/docker-compose.yml`` file:

   .. code-block:: bash

      sed -i '/postgresql/{n;N;d}' /opt/redash/docker-compose.yml

#. Edit the ``opt/redash/env`` file to enable the `permissions <https://github.com/getredash/redash/pull/1113>`__ feature:

   .. code-block:: bash

      echo 'REDASH_FEATURE_SHOW_PERMISSIONS_CONTROL=true' >> /opt/redash/env

#. Edit the ``opt/redash/env`` file to `configure the mail server <https://redash.io/help/open-source/setup#Mail-Configuration>`__.

#. Restart Redash:

   .. code-block:: bash

       docker-compose stop
       docker-compose up -d

#. Test the email configuration using the `Password Reset <https://redash.open-contracting.org/forgot>`__ feature.

.. _upgrade-redash:

Upgrade the Redash service
--------------------------

To upgrade Redash without creating a new server, `see the official documentation <https://redash.io/help/open-source/admin-guide/how-to-upgrade>`__.
