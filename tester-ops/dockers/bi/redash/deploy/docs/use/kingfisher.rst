Kingfisher
==========

Kingfisher is a family of tools to `collect <https://kingfisher-collect.readthedocs.io/en/latest/>`__, `pre-process <https://kingfisher-process.readthedocs.io/en/latest/>`__, `summarize <https://kingfisher-summarize.readthedocs.io/en/latest/>`__ and `query <https://kingfisher-colab.readthedocs.io/en/latest/>`__ OCDS data.

This page is about internal use of these tools by the Open Contracting Partnership. For your personal use, see each tool's documentation:

-  `Kingfisher Collect <https://kingfisher-collect.readthedocs.io/en/latest/>`__
-  `Kingfisher Process <https://kingfisher-process.readthedocs.io/en/latest/>`__
-  `Kingfisher Summarize <https://kingfisher-summarize.readthedocs.io/en/latest/>`__

For internal use, Kingfisher Collect, Process and Summarize are deployed to a main server.

If you are a new user of Kingfisher, subscribe to the `Kingfisher Status <https://groups.google.com/a/open-contracting.org/forum/#!forum/kingfisher-status>`__ mailing list, in order to receive notifications about major downtime.

The following pages describe specific tasks for each tool:

.. toctree::

   kingfisher-collect.rst
   kingfisher-process.rst
   kingfisher-summarize.rst

.. _connect-kingfisher-server:

Connect to servers
------------------

.. admonition:: One-time setup

   Ask a colleague to add your public SSH key to the ``ssh.kingfisher`` list in the ``pillar/kingfisher.sls`` file.

The ``ocdskfp`` user owns the deployments of Kingfisher Process and Kingfisher Summarize, and can read the data and log files of Kingfisher Collect.

Connect to the main server as the ``ocdskfp`` user, to use the command-line tools of `Kingfisher Process <https://kingfisher-process.readthedocs.io/en/latest/cli/>`__ and `Kingfisher Summarize <https://kingfisher-summarize.readthedocs.io/en/latest/cli.html>`__:

.. code-block:: bash

   curl --silent --connect-timeout 1 process.kingfisher.open-contracting.org:8255 || true
   ssh ocdskfp@process.kingfisher.open-contracting.org

This user has access to the `jq <https://stedolan.github.io/jq/manual/>`__, `flatten-tool <https://flatten-tool.readthedocs.io/en/latest/usage-ocds/>`__ and `ocdskit <https://ocdskit.readthedocs.io/en/latest/>`__ command-line tools.

.. note::

   The ``ocdskfs`` user owns the deployment of Kingfisher Collect and Kingfisher Archive. Only archival scripts and system administrators should manually delete any data and log files.
