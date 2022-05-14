Configure Apache
================

.. _allow-http:

Allow HTTP/HTTPS traffic
------------------------

Add to your service's Pillar file:

.. code-block:: yaml

   apache:
     public_access: True

This will:

-  Open ports 80 (HTTP) and 443 (HTTPS)
-  Install the Apache service
-  Enable the :ref:`mod_http2, mod_md and mod_ssl<apache-modules>` Apache modules
-  Enable an Apache configuration for acquiring Let's Encrypt certificates

If you are only using Apache to serve Python apps, continue from :doc:`python`.

.. _apache-sites:

Add sites
---------

Add to your service's Pillar file:

.. code-block:: yaml
   :emphasize-lines: 3-12

   apache:
     public_access: True
     sites:
       ocds-docs-live:
         configuration: docs
         servername: standard.open-contracting.org
         serveraliases: ['live.standard.open-contracting.org']
         context:
           testing: False
           ocds_cove_backend: https://cove.live3.cove.opencontracting.uk0.bigv.io
           oc4ids_cove_backend: https://cove-live.oc4ids.opencontracting.uk0.bigv.io
           timeout: 1830  # 30 sec longer than cove's uwsgi.harakiri

This will:

-  Create a ``/etc/apache2/sites-available/{site}.conf`` file that includes a ``/etc/apache2/sites-available/{site}.conf.include`` file, which, together:

   -  If ``apache.public_access`` is ``True`` and ``https`` isn't ``False``:

      -  :ref:`ssl-certificates`
      -  Configure a HTTP to HTTPS permanent redirect
      -  Add a ``Strict-Transport-Security`` header
      -  Configure `OCSP Stapling <https://en.wikipedia.org/wiki/OCSP_stapling>`__
      -  Create a virtual host serving port 443

   -  Create a virtual host serving port 80
   -  Set the virtual hosts' ``servername`` and ``serveraliases``, if any

-  Symlink the new files from the ``etc/apache2/sites-enabled`` directory
-  Reload the Apache service if the configuration changed

The example above uses the `docs <https://github.com/open-contracting/deploy/blob/main/salt/apache/files/sites/docs.conf.include>`__ configuration. The keys of the ``context`` mapping are made available as variables in the configuration template.

.. note::

   To delete a virtual host, :ref:`follow these instructions<delete-virtual-host>`.

Add basic authentication
~~~~~~~~~~~~~~~~~~~~~~~~

#. Add, in a private Pillar file:

   .. code-block:: yaml

      apache:
        sites:
          SITE:
            htpasswd:
              name: NAME
              password: PASSWORD

   This will add the user to the ``/etc/apache2/.htpasswd-SITE`` file.

#. Reference the htpasswd file from an Apache configuration file. For example:

   .. code-block:: apache

      <Location "/">
          ProxyPass http://localhost:6789/

          AuthName "My Site"
          AuthType Basic
          AuthUserFile /etc/apache2/.htpasswd-my-site
          Require valid-user
      </Location>

.. note::

   Only one htpasswd user is permitted per site, but this can be changed.

.. _ssl-certificates:

Acquire SSL certificates
------------------------

If ``apache.public_access`` is ``True`` and ``https`` isn't ``False``, `mod_md <https://httpd.apache.org/docs/2.4/mod/mod_md.html>`__ is used to acquire SSL certificates from Let's Encrypt. If the server name is new, you must:

#. :doc:`Deploy the service<../../deploy/deploy>`, if not already done.
#. ``mod_md`` will request a certificate from Let's Encrypt. Check for a message in ``/var/log/apache2/error.log``, replacing ``TARGET``:

   .. code-block:: bash

      ./run.py TARGET cmd.run 'grep "Managed Domain" /var/log/apache2/error.log'

   For example:

   .. code-block:: none

      AH10059: The Managed Domain ssl-test.open-contracting.org has been setup and changes will be activated on next (graceful) server restart.

#. Reload the Apache service, replacing ``TARGET``:

   .. code-block:: bash

      ./run.py TARGET service.reload apache2

The service should now be available at its ``https://`` web address.

Test
~~~~

Test the HTTP redirect, replacing ``SERVERNAME``:

.. code-block:: shell-session
   :emphasize-lines: 2,5

   $ curl -I http://SERVERNAME
   HTTP/1.1 301 Moved Permanently
   Date: Fri, 11 Dec 2020 12:34:56 GMT
   Server: Apache/2.4.46 (Ubuntu)
   Location: https://SERVERNAME/
   Content-Type: text/html; charset=iso-8859-1

Test the HTTPS response:

.. code-block:: shell-session
   :emphasize-lines: 2,5

   $ curl -IL https://SERVERNAME
   HTTP/2 200
   date: Fri, 11 Dec 2020 04:26:57 GMT
   server: Apache/2.4.46 (Ubuntu)
   strict-transport-security: max-age=15768000

Check the certificates' status:

.. code-block:: bash

   curl https://SERVERNAME/.httpd/certificate-status

Check `md-status <https://github.com/icing/mod_md#monitoring>`__, replacing ``TARGET``:

.. code-block:: bash

   ./run.py TARGET cmd.run 'curl -sS http://localhost/md-status'

Each certificate's OCSP ``"status"`` should be ``"good"``.

You can test the SSL configuration using `SSL Labs <https://www.ssllabs.com/ssltest/>`__.

Troubleshoot
~~~~~~~~~~~~

In case of error, see `mod_md's troubleshooting guide <https://github.com/icing/mod_md#how-to-fix-problems>`__. If you need to test the acquisition of certificates, `use Let's Encrypt's staging environment <https://github.com/icing/mod_md#dipping-the-toe>`__.

.. _apache-modules:

Enable Apache modules
---------------------

You might need to enable Apache modules to use non-core directives in your configuration files.

There are state files for common modules:

apache.modules.https
  Provides support for the `HTTP/2 protocol <https://httpd.apache.org/docs/2.4/mod/mod_http2.html>`__.
apache.modules.md
  Acquires `SSL certificates from Let's Encrypt <https://httpd.apache.org/docs/2.4/mod/mod_md.html>`__.
apache.modules.proxy
  Adds `ProxyPass, ProxyPreserveHost and other directives <https://httpd.apache.org/docs/2.4/en/mod/mod_proxy.html>`__. Included by ``apache.modules.proxy_http`` and ``apache.modules.proxy_uwsgi``.
apache.modules.proxy_http
  Provides support for `HTTP/HTTPS requests in ProxyPass directives <https://httpd.apache.org/docs/2.4/en/mod/mod_proxy_http.html>`__. Included by the ``python_apps`` state file.
apache.modules.proxy_uwsgi
  Provides supports for the `uWSGI protocol in ProxyPass directives <https://httpd.apache.org/docs/2.4/en/mod/mod_proxy_uwsgi.html>`__. Included by the ``python_apps`` state file.
apache.modules.remoteip
  Adds `RemoteIPHeader, RemoteIPTrustedProxy and other directives <https://httpd.apache.org/docs/2.4/en/mod/mod_remoteip.html>`__.
apache.modules.ssl
  Included and required by ``apache.modules.md``.
apache.modules.watchdog
  Included and required by ``apache.modules.md``.

To enable a module, include the relevant state file in your service's state file. For example:

.. code-block:: yaml

   include:
     - apache.modules.remoteip

If you need another module, consider adding a state file under the ``salt/apache/modules`` directory.

.. note::

   To disable an Apache module, :ref:`follow these instructions<delete-apache-module>`.
