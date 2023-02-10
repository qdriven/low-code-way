Maintain
========

If you don't understand why a configuration exists, it's useful to check its history.

The files in this repository were originally in the `opendataservices-deploy <https://github.com/OpenDataServices/opendataservices-deploy>`__ repository. You can `browse <https://github.com/OpenDataServices/opendataservices-deploy/tree/7a5baff013b888c030df8366b3de45aae3e12f9e>`__ that repository from before the switch (August 5, 2019). That repository was itself re-organized at different times. You can browse `before moving content from *.conf to *.conf.include <https://github.com/OpenDataServices/opendataservices-deploy/tree/4dbea5122e1fc01221c8d051efc99836cef98ccb>`__ (June 5, 2019).

Remove unneeded services and packages
-------------------------------------

We remove unneeded services and packages from this repository, because carrying old configurations forever into the future increases the maintenance burden of this repository.

If you don't know whether a package is still required, you can connect to the server and:

-  Show what files the package installs:

   .. code-block:: bash

      dpkg -L PACKAGE

-  Show what packages the package depends on:

   .. code-block:: bash

      apt show PACKAGE

-  Show what packages depends on this package:

   .. code-block:: bash

      apt rdepends PACKAGE

For example, the above commands show that ``redis`` is a metapackage (installing only documentation) that depends on ``redis-server``, and that ``python3-virtualenv`` provides library files whereas ``virtualenv`` provides a binary file (needed by Salt).

The ``./manage.py`` command has ``services`` and ``packages`` sub-commands to identify unusual services and packages, and an ``autoremove`` to list candidates for removal.

List manually installed packages
--------------------------------

This `StackOverflow answer <https://unix.stackexchange.com/a/141001>`__ works best. On Bytemark servers:

.. code-block:: bash

   comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)

On Hetzner servers, the ``/var/log/installer`` directory is missing. The Ubuntu manifest can be used as an approximation:

.. code-block:: bash

   comm -23 <(apt-mark showmanual | sort -u) <(curl -sS https://releases.ubuntu.com/bionic/ubuntu-18.04.5-live-server-amd64.manifest | cut -f1 | cut -d: -f1 | sort -u)

..
   https://unix.stackexchange.com/a/80520 is similar. Instead of `apt-mark showmanual`, it takes the packages that
   appear in `dpkg-query --show` and not in `apt-mark showauto`. The output includes linux-* packages.

   https://askubuntu.com/a/1279044 uses /var/log/installer/status (unavailable on Ubuntu 18.04).

   https://stackoverflow.com/a/60252818/244258 uses /var/log/installer/syslog (outputs more dependencies).

..
   Some other dead ends are...

   dpkg includes all dependencies:

      dpkg --get-selections | grep -v deinstall
      dpkg --list
      dpkg-query --list
      dpkg-query --show

   apt includes system packages:

      apt-mark showmanual
      apt list --manual-installed

   /var/log/apt/history.log has incomplete history.

      zgrep ' install ' /var/log/apt/history.log* | grep -oP '[^ ]+$' | sort

   /var/log/apt/term.log includes some dependencies.

      zgrep -oP 'package \K.+\.' /var/log/apt/term.log* | sed 's/\.$//' | cut -d: -f2 | sort | grep -v linux-

   /var/log/dpkg.log includes some dependencies, and any packages that were later removed.

      zgrep '[0-9] install' /var/log/dpkg.log* | cut -d' ' -f4 | cut -d: -f1 | sort | grep -v linux-
