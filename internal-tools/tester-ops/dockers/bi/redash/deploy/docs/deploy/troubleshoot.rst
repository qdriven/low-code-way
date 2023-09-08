Troubleshoot
============

.. _increase-verbosity:

Increase verbosity
------------------

.. code-block:: bash

   ./run.py --log-level=trace TARGET FUNCTION

Salt hangs inexplicably
-----------------------

If you haven't previously connected to a server using SSH, then ``./run.py`` will log a ``TRACE``-level message like:

.. code-block:: none

   The authenticity of host 'example.com (101.2.3.4)' can't be established.
   ECDSA key fingerprint is SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.
   Are you sure you want to continue connecting (yes/no/[fingerprint])?

You can also experience this issue if anyone changes the hostnames in the ``salt-config/roster`` file.

Unless you :ref`increase verbosity<increase-verbosity>`, you won't see this message, and ``./run.py`` will appear to hang.

To fix this, simply connect to the server using SSH, for example:

.. code-block:: bash

   curl --silent --connect-timeout 1 standard.open-contracting.org:8255 || true
   ssh root@standard.open-contracting.org

Then, re-run the ``./run.py`` command.

.. note::

   It is **not recommended** to use the ``-i`` (``--ignore-host-keys``) option, as this disables strict host key checking, allowing for man-in-the-middle attacks.

.. _watch-salt-activity:

Watch Salt activity
-------------------

If you want to check whether a deployment is simply slow or actually stalled, perform these steps:

#. Find the server's IP or fully-qualified domain name in the roster:

   .. code-block:: bash

      cat salt-config/roster

#. Open a secondary terminal to connect to the server as root, for example:

   .. code-block:: bash

      curl --silent --connect-timeout 1 standard.open-contracting.org:8255 || true
      ssh root@standard.open-contracting.org

#. Watch the processes on the server:

   .. code-block:: bash

      watch -n 1 pstree

#. Look at the lines below these:

.. code-block:: none

    |-sshd-+-sshd---bash---watch
    |      |-sshd---bash---watch---watch---sh---pstree

Then, once the deployment is done:

#. Stop watching the processes, e.g. with ``Ctrl-C``
#. Disconnect from the server, e.g. with ``Ctrl-D``

.. _restart-service:

Restart a service
-----------------

Services should restart normally. To manually restart a service, run, for example:

.. code-block:: bash

   ./run.py TARGET service.restart uwsgi
