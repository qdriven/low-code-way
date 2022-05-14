Connect to a server (SSH)
=========================

.. admonition:: One-time setup

   :ref:`Add your public SSH key to the relevant remote servers<add-public-key>`.

By default, the SSH port is closed. The easiest way to open it depends on whether your IP address is dynamic or static.

Dynamic IP: Port knock
----------------------

To open the SSH port for 30 seconds, send traffic to port 8255, replacing ``example.open-contracting.org`` with the server you want to connect to:

.. code-block:: bash

   curl --silent --connect-timeout 1 example.open-contracting.org:8255 || true

You can then use ``ssh`` as usual. Once you're connected, the server will close the port, but not your connection.

.. note::

   Port 8255 returns no data. Without ``--connect-timeout 1``, curl waits forever for a response.

If you are working on this repository, you can also run:

.. code-block:: bash

   ./manage.py connect user@host

Static IP: Allow list
---------------------

#. Add your IP address to the ``firewall.ssh_ipv4`` and ``firewall.ssh_ipv6`` lists in the `common <https://github.com/open-contracting/deploy-pillar-private/blob/main/common.sls>`__ private Pillar file
#. Add your full name in a comment
#. :doc:`Deploy all services<../deploy/deploy>`

If you're unsure, contact sysadmin@open-contracting.org.
