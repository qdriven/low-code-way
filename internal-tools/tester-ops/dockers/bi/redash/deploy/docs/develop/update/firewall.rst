Configure firewall
==================

The `firewall.sh script <https://github.com/open-contracting/deploy/blob/main/salt/core/firewall/files/firewall.sh>`__ closes most ports by default. Its behavior is controlled by variables in the `firewall-settings.local file <https://github.com/open-contracting/deploy/blob/main/salt/core/firewall/files/firewall-settings.local>`__.

Most variables are set by state files:

SSH_IPV4 and SSH_IPV6
  IPs from which to allow SSH collections. Set by the ``firewall`` state using Pillar data. See :doc:`../../use/ssh`.
PUBLIC_HTTP
  Opens port 80. Set by the ``apache`` state.
PUBLIC_HTTPS
  Opens port 443. Set by the ``apache`` state.
PUBLIC_POSTGRESQL
  Opens port 5432. Set by the ``postgres`` state, if ``postgres.public_access`` is ``True`` in Pillar.
PRIVATE_POSTGRESQL
  Opens port 5432 to the replica servers. Set by the ``postgres`` state, if ``postgres.public_access`` isn't ``True`` in Pillar.
REPLICA_IPV4 and REPLICA_IPV6
  The IPs of replica servers. Set by the ``postgres`` state using Pillar data, if ``postgres.public_access`` isn't ``True`` in Pillar.
PUBLIC_ELASTICSEARCH
  Opens port 9200. Set by the ``elasticsearch`` state.
PUBLIC_TINYPROXY
  Opens port 8888. Set by the ``tinyproxy`` state.
PRIVATE_PROMETHEUS_CLIENT
  Opens port 7231 to the Prometheus server. Set by the ``prometheus.node_exporter`` state.
PROMETHEUS_IPV4 and PROMETHEUS_IPV6
  The IPs of the Prometheus server. Set by the ``prometheus.node_exporter`` state using Pillar data.

Other variables are:

PUBLIC_SSH
  Opens port 22. Supersedes :doc:`port knocking<../../use/ssh>`.

Open a port
-----------

If no variable corresponds to the port you need to open, update the ``firewall.sh`` script and ``firewall-settings.local`` template.

You might need to set variables if you're working in a development environment. To set a variable, use the ``set_firewall`` macro, for example:

   .. code-block:: yaml

      {{ set_firewall("PUBLIC_SSH") }}

This sets ``PUBLIC_SSH="yes"`` in the ``firewall-settings.local`` file.

Close a port
------------

Use the :ref:`unset_firewall macro<delete-firewall-setting>` if a ``set_firewall`` call is removed from a service's state, whether directly (by deleting a ``set_firewall`` call) or indirectly (by un-including a state file with ``set_firewall`` calls).

Debug network issues
--------------------

When making changes to firewall settings or port assignments, you might want to:

-  Check if a port is open:

   .. code-block:: bash

      telnet host port

-  List active connections:

   .. code-block:: bash

      netstat -tupln
