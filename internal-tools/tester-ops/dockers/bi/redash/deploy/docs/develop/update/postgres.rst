Configure PostgreSQL
====================

Specify the version
-------------------

The default version is 11.

To override the version, update the server's Pillar file:

.. code-block:: yaml
  :emphasize-lines: 2

  postgres:
    version: 11

.. _postgres-public-access:

Enable public access
--------------------

By default, PostgreSQL only allows local connections (`see the template for the pg_bha.conf configuration file <https://github.com/open-contracting/deploy/blob/main/salt/postgres/files/pg_hba.conf>`__).

To enable public access, update the server's Pillar file:

.. code-block:: yaml
  :emphasize-lines: 2

  postgres:
    public_access: True

Add your configuration
----------------------

#. Put your configuration file in the `salt/postgres/files/conf <https://github.com/open-contracting/deploy/tree/main/salt/postgres/files/conf>`__ directory.

#. Update the server's Pillar file. `Follow PostgreSQL's instructions <https://www.postgresql.org/docs/11/kernel-resources.html#LINUX-HUGE-PAGES>`__ for setting ``vm.nr_hugepages``:

  .. code-block:: yaml
    :emphasize-lines: 2

    postgres:
      configuration: kingfisher-process1
    vm:
      nr_hugepages: 1234

#. :doc:`Deploy<../../deploy/deploy>`

The configuration file will be in the ``/etc/postgresql/11/main/conf.d/`` directory on the server (for PostgreSQL version 11).

.. _pg-setup-replication:

Set up replication
------------------

To configure a main server and a replica server:

#. Create configuration files for each server, as above. For reference, see the files for ``kingfisher-process1`` and ``kingfisher-replica1``.

#. Add the replica's IP addresses to the main server's Pillar file:

   .. code-block:: yaml

      postgres:
        replica_ipv4:
          - 148.251.183.230
        replica_ipv6:
          - 2a01:4f8:211:de::2

#. Add the ``replica`` user to the main server's private Pillar file:

   .. code-block:: yaml

      postgres:
        users:
          replica:
            password: example_password
            replication: True

   .. note::

      If the ``replica`` user's password is changed, you must manually update the ``/var/lib/postgresql/11/main/recovery.conf`` file on the replica server (for PostgreSQL version 11).

#. Add the ``postgres.main`` state file to the main server's target in the ``salt/top.sls`` file.

#. :doc:`Deploy<../../deploy/deploy>` both servers

#. Connect to the main server as the ``root`` user, and create a replication slot, replacing ``SLOT``:

   .. code-block:: bash

      su - postgres
      psql -c "SELECT * FROM pg_create_physical_replication_slot('SLOT');"

#. Transfer data and start replication (all commands are for PostgreSQL version 11).

   #. Connect to the replica server as the ``root`` user.

   #. Stop the PostgreSQL service and delete the main cluster's data.

      .. code-block:: bash

         service postgresql stop
         rm -rf /var/lib/postgresql/11/main

   #. Switch to the ``postgres`` user and transfer data, replacing ``MAIN_HOST``:

      .. code-block:: bash

         su - postgres
         pg_basebackup -h MAIN_HOST -U replica --slot={slot} \
             -D /var/lib/postgresql/11/main --write-recovery-conf --verbose --progress

      For example, for ``kingfisher-replica``:

      .. code-block:: bash

         pg_basebackup -h process1.kingfisher.open-contracting.org -U replica --slot=replica1 \
             -D /var/lib/postgresql/11/main --write-recovery-conf --verbose --progress

      .. note::

         The `--write-recovery-conf option <https://www.postgresql.org/docs/11/app-pgbasebackup.html>`__ writes a ``/var/lib/postgresql/11/main/recovery.conf`` file, with ``standby_mode``, ``primary_conninfo`` and ``primary_slot_name`` lines.

   #. Enable automatic WAL archive restoration on the replica server:

      .. code-block:: bash

         echo "restore_command = 'cp /var/lib/postgresql/11/main/archive/%f %p'" >> /var/lib/postgresql/11/main/recovery.conf

   #. Switch to the ``root`` user and start the PostgreSQL service.

      .. code-block:: bash

         exit
         service postgresql start

   #. Double-check that the service started:

      .. code-block:: bash

         pg_lsclusters

Once you're done, the ``/var/lib/postgresql/11/main/recovery.conf`` file on the replica server will look like:

.. code-block:: none

  standby_mode = 'on'
  primary_conninfo = 'user=replica password=redacted host=process1.kingfisher.open-contracting.org port=5432 sslmode=prefer sslcompression=0 gssencmode=prefer krbsrvname=postgres target_session_attrs=any'
  primary_slot_name = 'replica1'
  restore_command = 'cp /var/lib/postgresql/11/main/archive/%f %p'

.. _pg-ssh-key-setup:

Create SSH keys for replica recovery
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to access the WAL archive for recovery, we need to set up SSH keys this enables communication between the replica server and the main source server.

.. note::

   You can find the :ref:`recovery steps here<pg-recover-replica>`.

#. Log into your replica server
#. Swap to the postgres user

   .. code-block:: bash

      su - postgres

#. Generate new SSH keys

   .. code-block:: bash

      ssh-keygen -t rsa -b 4096

   This creates both a public (`~/.ssh/id_rsa.pub`) and private key (`~/.ssh/id_rsa`)

#. Add these new keys in deploy pillar

   #. Add the public key to `authorized_keys` on the main server

      .. code-block:: yaml

         ssh:
           postgres:
             - ssh-rsa AAAB3N...

   #. Add the private key to `deploy-pillar-private <https://github.com/open-contracting/deploy-pillar-private>`__.

      .. code-block:: yaml

         postgres:
           ssh_key: |
             -----BEGIN RSA PRIVATE KEY-----
             ...

   #. :doc:`Deploy<../../deploy/deploy>`
