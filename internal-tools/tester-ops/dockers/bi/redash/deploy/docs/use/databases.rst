SQL databases
=============

.. note::

   If you need to create temporary tables, use ``CREATE TEMPORARY TABLE``. If you need to create persistent tables, create a new schema first; do not create tables in the ``public`` schema.

Connect to a database
---------------------

.. note::

   To query the database directly from your personal computer, please `request a personal SQL user account <https://github.com/open-contracting/deploy/issues/new/choose>`__, and configure :ref:`psql`, :ref:`beekeeper` and/or :ref:`pgadmin` to use it.

   For most use cases, you can instead query the database from `Redash <https://redash.open-contracting.org>`__. To request an account, email data@open-contracting.org.

OCP has a main database on the ``postgres.kingfisher.open-contracting.org`` server, and provides a replica database on the ``postgres-readonly.kingfisher.open-contracting.org`` server, in order to ease the load on the main server. Please always use the replica database. If that server goes down, use the main database until the server is restored.

.. _psql:

psql
~~~~

If PostgreSQL is installed, you can use `psql <https://www.postgresql.org/docs/11/app-psql.html>`__, PostgreSQL's interactive terminal, from the command-line.

For security, remember to set ``sslmode`` to ``require``.

.. code-block:: bash

   psql "dbname=DBNAME user=USERNAME host=HOST sslmode=require"

For example:

.. code-block:: bash

   psql "dbname=ocdskingfisherprocess user=jmckinney host=postgres-readonly.kingfisher.open-contracting.org sslmode=require"

Instead of entering your password each time, you can add your credentials to the `PostgreSQL Password File <https://www.postgresql.org/docs/11/libpq-pgpass.html>`__, replacing ``USER`` and ``PASS``:

.. code-block:: bash

   echo 'postgres-readonly.kingfisher.open-contracting.org:5432:ocdskingfisherprocess:USER:PASS' >> ~/.pgpass

Then, set the permissions of the ``~/.pgpass`` file:

.. code-block:: bash

   chmod 600 ~/.pgpass

.. _beekeeper:

Beekeeper Studio
~~~~~~~~~~~~~~~~

`Beekeeper Studio <https://www.beekeeperstudio.io>`__ is a cross-platform app for querying databases.

For security, remember to check *Enable SSL*.

#. Select "Postgres" from *Connection Type*
#. Set the *Host*, e.g. "postgres-readonly.kingfisher.open-contracting.org"
#. Check *Enable SSL*
#. Set the *User*
#. Set the *Password*
#. Set the *Default Database*, e.g. "ocdskingfisherprocess"
#. Click the *Test* button

Then, either click the *Connect* button or set the *Connection Name* and click *Save*.

.. _pgadmin:

pgAdmin
~~~~~~~

`pgAdmin <https://www.pgadmin.org>`__ is a locally hosted web interface for querying databases.

For security, remember to set *SSL mode* to "Require".

#. Open the *Object > Create > Server...* menu item
#. Set the *Name*, e.g. "Kingfisher"
#. Click the *Connection* tab
#. Set the *Host name/address*, e.g. "postgres-readonly.kingfisher.open-contracting.org"
#. Set the *Username*
#. Set the *Password*
#. Check *Save password?*
#. Click the *SSL* tab
#. Set *SSL mode* to "Require"
#. Click the *Save* button

To avoid unnecessary queries to the database, please make these one-time configuration changes:

#. Open the *File > Preferences* menu item
#. Click *Display* under *Dashboards* in the sidebar
#. Uncheck *Show activity?*
#. Uncheck *Show graphs?*
#. Click the *Save* button

Google Colaboratory
~~~~~~~~~~~~~~~~~~~

`Google Colaboratory <https://colab.research.google.com/notebooks/welcome.ipynb>`__ is an executable document to write, run and share code in Google Drive, similar to `Jupyter Notebook <https://jupyter.org>`__.

Install the `ocdskingfishercolab <https://pypi.org/project/ocdskingfishercolab/>`__ Python package, which installs the `ipython-sql <https://pypi.org/project/ipython-sql/>`__ Python package.

For security, remember to set ``sslmode`` to ``'require'``.

.. code-block:: none

   %sql postgresql://USER:PASSWORD@postgres-readonly.kingfisher.open-contracting.org/ocdskingfisherprocess?sslmode=require

.. note::

   There is an open issue to use `Colaboratory Forms <https://colab.research.google.com/notebooks/forms.ipynb>`__ to store credentials.

Python
~~~~~~

`Python <https://www.python.org>`__ is the programming language in which many OCDS tools are written.

Install the `psycopg2 <https://pypi.org/project/psycopg2/>`__ Python package.

For security, remember to set ``sslmode`` to ``'require'``.

.. code-block:: python

   import psycopg2

   conn = psycopg2.connect(
       dbname='ocdskingfisherprocess',
       user='USER',
       password='PASSWORD',
       host='postgres-readonly.kingfisher.open-contracting.org',
       sslmode='require')
