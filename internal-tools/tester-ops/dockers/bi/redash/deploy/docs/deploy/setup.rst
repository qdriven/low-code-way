Get deploy token
================

Before performing any deployment task, run the *Setup* tasks below. Once done, run the *Cleanup* tasks below. If you haven't already, please follow the :doc:`../develop/get_started` guide.

.. _generic-setup:

Setup
-----

1. Update deploy repositories
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure the ``deploy``, ``pillar/private``, ``salt/private`` and ``salt/maintenance`` repositories are on the default branch and are up-to-date. You can run this convenience script to run the appropriate ``git`` commands:

.. code-block:: bash

    ./script/update

Check the output in case there are any issues switching to the default branch or any conflicts pulling from GitHub.

.. _check-if-kingfisher-is-busy:

2. Check if Kingfisher is busy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

   Skip this step unless you're working on Kingfisher.

#. :ref:`Access Scrapyd's web interface<access-scrapyd-web-service>`, click *Jobs* and look under *Running*. If any spiders are running, don't deploy without the consent of helpdesk analysts.

#. Connect to the Kingfisher server as the ``root`` user:

   .. code-block:: bash

      curl --silent --connect-timeout 1 collect.kingfisher.open-contracting.org:8255 || true
      ssh root@collect.kingfisher.open-contracting.org

#. Check if any :ref:`long-running tasks<tmux>` are running, by attaching to each session in ``tmux`` to see which commands are running. If any commands would be interrupted by the deployment, don't deploy without the consent of the helpdesk analysts, who should be identified by the session names.

   To list all sessions:

   .. code-block:: bash

      for i in root ocdskfp; do echo $i; su $i -c "tmux ls"; done

#. If the ``postgres`` service would be restarted by the deployment (for example, due to a configuration change or a package upgrade), check if any :ref:`long-running queries<pg-stat-activity>` are running. If there are queries with a ``state`` of ``active`` and a ``time`` greater than an hour, don't deploy without the consent of the helpdesk analysts, who should be identified by the ``usename``, ``client_addr`` or comment at the start of ``query``.

If you must deploy while spiders are running, see how to :ref:`deploy Kingfisher Process without losing Scrapy requests<deploy-kingfisher-process>`.

3. Get deploy token
~~~~~~~~~~~~~~~~~~~

Only one person should be making changes to a server at once. To implement this rule, the `Deploy token <https://docs.google.com/document/d/1kW2hI1PYYd8KC5QDyys8clPvshBMUZuLpEOO-DvSxqk/edit>`__ document indicates who "holds the deploy token." Whoever holds the deploy token is the only person who can make changes to *any* server, until the deploy token is released. If the document has "Held by: <NAME>", that person holds the token. If it has "Held by: Nobody", then the token is released. To hold the token:

#. Go to the `Deploy token <https://docs.google.com/document/d/1kW2hI1PYYd8KC5QDyys8clPvshBMUZuLpEOO-DvSxqk/edit>`__ document

   * If "Held by" is followed by a person's name, wait until the deploy token is released

#. Replace "Nobody" with your name

.. _generic-cleanup:

Cleanup
-------

1. Release deploy token
~~~~~~~~~~~~~~~~~~~~~~~

#. Go to the `Deploy token <https://docs.google.com/document/d/1kW2hI1PYYd8KC5QDyys8clPvshBMUZuLpEOO-DvSxqk/edit>`__ document
#. Replace your name with "Nobody"
#. Append an entry to the `Deploy history <https://docs.google.com/spreadsheets/d/1lmX7c5PQ83lzhPK2y91RmOO4nv9Di4jzA2yn0ZdFIjY/edit#gid=0>`__ spreadsheet
