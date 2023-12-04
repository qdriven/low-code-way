Periodic tasks
==============

.. _review-root-access:

Review root access
------------------

#. Read the :ref:`root access policy<root-access-policy>`
#. Update the ``ssh.root`` lists in Pillar files and the ``ssh.admin`` list in the ``pillar/common.sls`` file
#. :doc:`Deploy<../deploy/deploy>` the affected services

.. _clean-root-user-directory:

Clean root user directory
-------------------------

#. Run:

   .. code-block:: bash

      ./run.py '*' cmd.run 'ls'

#. Leave any ``post.install.log`` files
#. Delete any ``index.html*`` files

   -  These are created when a developer runs ``wget`` commands to e.g. test proxy settings.

.. _check-drive-usage:

Check drive usage
-----------------

If ``ncdu`` is installed, change to the root directory and run the ``ncdu`` command.

.. _check-mail:

Check mail
----------

Find saved messages across servers:

.. code-block:: bash

   ./run.py '*' cmd.run 'find /root /home/* -maxdepth 0 -name mbox'

Find mailboxes with mail across servers:

.. code-block:: bash

   ./run.py '*' cmd.run 'find /var/mail -type f -not -size 0'

Connect to a server, for example:

.. code-block:: bash

   curl --silent --connect-timeout 1 process.kingfisher.open-contracting.org:8255 || true
   ssh root@process.kingfisher.open-contracting.org

Open the mailbox:

.. code-block:: bash

   mail -f /var/mail/root

You might see a lot of repeat messages.

Here are common `commands <https://www.johnkerl.org/doc/mail-how-to.html>`__:

-  number: open that message
-  ``h``: show a screen of messages
-  ``z``: go to the next screen
-  ``d 5-10``: delete the messages 5 through 10
-  ``d *``: delete all messages
-  ``q``: save changes and exit
-  ``x``: exit without saving changes

In most cases, all messages can be ignored and deleted. Relevant messages might include:

Failed cron jobs
   Try to correct the failure
Failed attempts to use sudo
   If the attempt is not attributable to a team member, discuss security measures

Auto-remove packages
--------------------

To show the packages that were automatically installed and are no longer required:

.. code-block:: bash

   ./run.py 'docs' pkg.autoremove list_only=True

It is generally safe to remove these. Run:

.. code-block:: bash

   ./run.py 'docs' pkg.autoremove purge=True

You can omit ``purge=True`` to make it easier to restore a package.

To show the packages that were removed but not purged, run:

.. code-block:: bash

   ./run.py '*' pkg.list_pkgs removed=True

.. _rescale-server:

Upgrade Ubuntu
--------------

To determine the current releases, run:

.. code-block:: bash

   ./run.py '*' cmd.run 'lsb_release -a'

To check the long term support of the releases, consult the `Ubuntu documentation <https://ubuntu.com/about/release-cycle>`__.
