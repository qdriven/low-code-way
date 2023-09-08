OCDS documentation tasks
========================

Clean draft documentation
-------------------------

#. Connect to the server:

   .. code-block:: bash

      curl --silent --connect-timeout 1 standard.open-contracting.org:8255 || true
      ssh root@standard.open-contracting.org

#. Switch to the ``ocds-docs`` user:

   .. code-block:: bash

      su - ocds-docs

#. Run ``1-size.sh`` to get the total sizes of old drafts. For example, for drafts older than 180 days:

   .. code-block:: bash

      ./1-size.sh 180

#. Run ``2-delete.sh`` to delete the old drafts. For example, for drafts older than 180 days:

   .. code-block:: bash

      ./2-delete.sh 180

Check 404 errors
----------------

#. Connect to the server:

   .. code-block:: bash

      curl --silent --connect-timeout 1 standard.open-contracting.org:8255 || true
      ssh root@standard.open-contracting.org

#. Count 404 errors:

   .. code-block:: bash

      zgrep " 404 " /var/log/apache2/other_vhosts_access.log* | cut -d ' ' -f 8 | sort | uniq -c | sort -n
