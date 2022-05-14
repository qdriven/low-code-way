Delete a server
===============

A server is deleted either when a service is moving to a new server (:doc:`create the new server<create_server>`, first), or when a service is being retired.

As with other deployment tasks, do the :ref:`setup tasks<generic-setup>` before (and the :ref:`cleanup tasks<generic-cleanup>` after) the steps below.

#. If appropriate, notify relevant users of the change
#. Remove the server from ``salt/prometheus/server/files/config/conf-prometheus.yml``
#. :doc:`Deploy<deploy>` the Prometheus service
#. Shutdown the server via the :ref:`host<hosting>`'s interface
#. Remove all occurrences of the server's FQDN and IP address from this repository

If the service is being retired:

#. Remove its configuration from this repository
#. Remove its DNS entries from `GoDaddy <https://dcc.godaddy.com/manage/OPEN-CONTRACTING.ORG/dns>`__
#. Remove its error monitor from `Sentry <https://sentry.io/organizations/open-contracting-partnership/projects/>`__
#. Remove its row from the `Health of software products and services <https://docs.google.com/spreadsheets/d/1MMqid2qDto_9-MLD_qDppsqkQy_6OP-Uo-9dCgoxjSg/edit#gid=1480832278>`__ spreadsheet
#. Remove its managed passwords, if appropriate

Finally:

#. Cancel the server via the host's interface
