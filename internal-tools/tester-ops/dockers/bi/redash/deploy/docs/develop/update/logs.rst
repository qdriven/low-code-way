Configure rsyslog and logrotate
===============================

rsyslog
-------

To add an rsyslog configuration file:

#. Add a configuration file to ``salt/core/rsyslog/files``
#. Add a mapping to the service's Pillar file

For example:

.. code-block:: yaml

   rsyslog:
     conf:
       92-kingfisher-archive.conf: kingfisher-archive.conf

The ``kingfisher-archive.conf`` file in ``salt/core/rsyslog/files`` will be written to ``/etc/rsyslog.d/92-kingfisher-archive.conf``, and the ``rsyslog`` service will be restarted.

logrotate
---------

#. Add a configuration file to ``salt/core/logrotate/files``
#. Add a mapping to the service's Pillar file

For example:

.. code-block:: yaml

   logrotate:
     conf:
       archive: kingfisher-archive

The ``kingfisher-archive`` file in ``salt/core/logrotate/files`` will be written to ``/etc/logrotate.d/archive``.
