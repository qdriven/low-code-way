Reference
=========

Communicating during downtime
-----------------------------

Please see the `protocol <https://docs.google.com/document/d/1qAoh2scU5ZMGC_WYFjjNNJU-34NzYaC4V2xjmb2G75k/edit>`__ for planned and unplanned downtime.

Monitoring
----------

Prometheus
~~~~~~~~~~

Servers are monitored by `Prometheus <https://prometheus.io/>`__. Salt is used to:

-  Install a `Node Exporter <https://github.com/prometheus/node_exporter>`__ service on each server, to export hardware and OS metrics like disk space used, memory used, etc.
-  Set up a Prometheus server to collect metrics from all servers, and to email alerts if metrics are out of bounds

Read the :doc:`user guide <../use/prometheus>` to learn how to use Prometheus.

DMARC Analyzer
~~~~~~~~~~~~~~

OCP's `DMARC policy <https://support.google.com/a/answer/2466563>`__ (``dig TXT _dmarc.open-contracting.org``) sends aggregate and forensic reports to `DMARC Analyzer <https://app.dmarcanalyzer.com/>`__.

Sentry
~~~~~~

Application errors are reported to `Sentry <https://sentry.io/organizations/open-contracting-partnership/projects/>`__, which notifies individual email addresses. All Salt-managed, OCP-authored services report errors to Sentry.

There should be at most one `member <https://sentry.io/settings/open-contracting-partnership/members/>`__ with the Admin role from each of ODS and CDS, and at least one member with the Owner role from OCP.

.. _hosting:

Hosting
-------

All servers (not services) are managed by `Dogsbody Technology <https://www.dogsbody.com>`__ (sysadmin@dogsbody.com). Servers are hosted by:

-  `Linode <https://cloud.linode.com/>`__ for the `Helpdesk CRM <https://crm.open-contracting.org>`__

   -  `Network status <https://status.linode.com/>`__: The relevant systems are: Regions: EU-West (London), Backups: EU-West (London) Backups.
   -  **Access**: The 'opencontractingpartnership' and 'opencontracting-dogsbody' users have full access.
   -  **Backups**: It is configured to have one daily backup and two weekly backups. Dogsbody also configured daily and weekly backups to `Google Cloud Platform <https://ocds-standard-development-handbook.readthedocs.io/en/latest/systems/services.html#cloud-platform>`__.

-  `Hetzner <https://robot.your-server.de/server>`__ for Kingfisher

   -  `Network status <https://www.hetzner-status.de/en.html>`__

-  `Bytemark <https://panel.bytemark.co.uk/servers>`__ for all others

   -  `Network status <https://status.bytemark.org/>`__
   -  **Access**: The 'opendataservices' and 'opencon-tech' users have secondary access to the 'opencontracting' account.
   -  **Backups**: It is configured to have one weekly backup (see :doc:`../deploy/create_server`).

-  GitHub Pages for the `Extension Explorer <https://extensions.open-contracting.org/>`__

   -  `Network status <https://www.githubstatus.com>`__

Administrative access
---------------------

The staff of the following organizations can have administrative roles:

-  `Open Contracting Partnership <https://www.open-contracting.org/about/team/>`__ (OCP)
-  `Centro de Desarrollo Sostenible <http://www.cds.com.py>`__ (CDS)
-  `Dogsbody Technology <https://www.dogsbody.com>`__
-  `Open Data Services Co-operative <https://opendataservices.coop>`__ (ODS)
-  `Young Innovations <https://younginnovations.com.np>`__

The ``ssh.root`` lists in Pillar files and the ``ssh.admin`` list in the ``pillar/common.sls`` file give people access to servers. All people should belong to the above organizations.

.. _root-access-policy:

Root access
~~~~~~~~~~~

Server owners (OCP) and server managers (Dogsbody) should have root access to all servers. Otherwise, only developers who are reasonably expected to deploy to a server should have root access to that server.

If a developer did not deploy (and was not granted root access) to a server within the last six months, their root access to that server should be revoked.

If a developer intends to deploy to a server, anyone with root access can grant that developer root access to that server.

Root access should be :ref:`routinely reviewed<review-root-access>`.

Redash
~~~~~~

There should be a minimum of two `admin <https://redash.open-contracting.org/groups/1>`__ members from OCP, and at most two from CDS and ODS.

Redmine
~~~~~~~

There should be a minimum of two `Administrator <https://crm.open-contracting.org/users?sort=admin%3Adesc%2Clogin>`__ roles from OCP, and at most two from CDS and ODS.

.. toctree::
   :caption: Service-specific information

   docs.rst
