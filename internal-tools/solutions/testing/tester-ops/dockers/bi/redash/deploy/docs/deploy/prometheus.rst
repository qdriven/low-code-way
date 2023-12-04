Prometheus tasks
================

Monitor a service
-----------------

If the ``prometheus.node_exporter`` state file applies to the target, then `Node Exporter <https://github.com/prometheus/node_exporter>`__ is served on port 7231 using the HTTPS scheme and a self-signed certificate. Only connections from the Prometheus server are allowed.

#. Add a job to ``salt/prometheus/server/files/config/conf-prometheus.yml``.

#. :doc:`Deploy<deploy>` the Prometheus service.

#. Check that the job is "UP" on Prometheus' `Targets <https://monitor.prometheus.open-contracting.org/targets>`__ page.

.. note::

   To test the Node Exporter endpoint from the Prometheus server, replace ``SUBDOMAIN`` with the target's subdomain, and ``PASSWORD`` with the URL-encoded value of the ``prometheus.node_exporter.password`` variable in the ``pillar/private/prometheus_client.sls`` file:

   .. code-block:: bash

      cd ~prometheus-client
      curl -v --cacert node_exporter.pem https://prom:PASSWORD@SUBDOMAIN.open-contracting.org:7231/metrics

Test Alert Manager
------------------

.. code-block:: bash

   curl --silent --connect-timeout 1 alertmanager.prometheus.open-contracting.org:8255 || true
   ssh root@alertmanager.prometheus.open-contracting.org
   curl -H "Content-Type: application/json" -d '[{"labels":{"alertname":"TestAlert"}}]' localhost:9095/api/v1/alerts

Reference: `StackOverflow <https://github.com/prometheus/alertmanager/issues/437>`__

Upgrade Prometheus
------------------

We set the version numbers of the Prometheus software in the ``pillar/prometheus_client.sls`` and ``pillar/prometheus_server.sls`` files:

-  ``prometheus.prometheus.version``
-  ``prometheus.alertmanager.version``
-  ``prometheus.node_exporter.version``

Our practice is to upgrade annually. We can upgrade sooner if there is a release with a bugfix or feature that we want.

Setup
~~~~~

#. Access the changelogs for the `Server <https://github.com/prometheus/prometheus/releases>`__, `Alert Manager <https://github.com/prometheus/alertmanager/releases>`__ and `Node Exporter <https://github.com/prometheus/node_exporter/releases>`__ (they follow `semantic versioning <https://semver.org/>`__).

#. Check whether any breaking changes are relevant to us. In particular, check whether newer versions work with data from older versions (the server and alert manager store data on disk).

Deploy
~~~~~~

Once you're ready to upgrade, as with other deployment tasks, do the :ref:`setup tasks<generic-setup>` before (and the :ref:`cleanup tasks<generic-cleanup>` after) the steps below.

#. Change the version numbers in the ``pillar/prometheus_client.sls`` and ``pillar/prometheus_server.sls`` files. (To test locally, you can :ref:`use to a virtual machine<using-a-virtual-machine>`.)

#. If you're upgrading the server and/or alert manager, deploy the ``prometheus`` target.

#. If you're upgrading the node exporter, deploy all targets.
