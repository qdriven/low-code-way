Kingfisher Collect
==================

Read the `Kingfisher Collect <https://kingfisher-collect.readthedocs.io/en/latest/>`__ documentation, which covers general usage.

.. note::

   Is the service unresponsive or erroring? :doc:`Follow these instructions<index>`.

Review a new publication
------------------------

#. `Create an issue <https://github.com/open-contracting/kingfisher-collect/issues/new/choose>`__ in the `kingfisher-collect <https://github.com/open-contracting/kingfisher-collect/issues>`__ repository. CDS and James will prioritize it.
#. :ref:`Schedule a crawl<collect-data>`, once the spider is written and :ref:`deployed<update-spiders>` by CDS.
#. :ref:`Wait for the crawl to finish<access-scrapyd-web-service>`.
#. :ref:`Review the crawl's log file<kingfisher-collect-review-log-files>`.
#. Review the data.

.. _access-scrapyd-web-service:

Access Scrapyd's web interface
------------------------------

.. admonition:: One-time setup

   Save the username (``scrape``) and the password (ask a colleague) in your password manager. (If you have access, the password is the value of the ``kingfisher_collect.web.password`` key in the ``pillar/private/kingfisher.sls`` file.)

Open https://collect.kingfisher.open-contracting.org to view the statuses and logs of crawls.

.. _collect-data:

Collect data with Kingfisher Collect
------------------------------------

.. admonition:: One-time setup

   :ref:`Create a ~/.netrc file<create-netrc-file>`.

First, `read this section <https://kingfisher-collect.readthedocs.io/en/latest/scrapyd.html#collect-data>`__ of the Kingfisher Collect documentation.

To schedule a crawl, replace ``spider_name`` with a spider's name and ``NAME`` with your name (you can edit the note any way you like), and run, from your computer:

.. code-block:: bash

   curl -n https://collect.kingfisher.open-contracting.org/schedule.json -d project=kingfisher -d spider=spider_name -d note="Started by NAME."

You should see a response like:

.. code-block:: json

   {"node_name": "process1", "status": "ok", "jobid": "6487ec79947edab326d6db28a2d86511e8247444"}

To cancel a crawl, replace ``JOBID`` with the job ID from the response or from Scrapyd's `jobs page <https://collect.kingfisher.open-contracting.org/jobs>`__:

.. code-block:: bash

   curl -n https://collect.kingfisher.open-contracting.org/cancel.json -d project=kingfisher -d job=JOBID

You should see a response like:

.. code-block:: json

   {"node_name": "process1", "status": "ok", "prevstate": "running"}

The crawl won't stop immediately. You can force an unclean shutdown by sending the request again; however, it's preferred to allow the crawl to stop gracefully, so that the log file is completed.

.. _update-spiders:

Update spiders in Kingfisher Collect
------------------------------------

.. admonition:: One-time setup

   :ref:`Create a ~/.netrc file<create-netrc-file>`. Then, `create a ~/.config/scrapy.cfg file <https://kingfisher-collect.readthedocs.io/en/latest/scrapyd.html#configure-kingfisher-collect>`__, and set the ``url`` variable to ``https://collect.kingfisher.open-contracting.org/``.

#. Change to your local directory containing your local repository

#. Ensure your local repository and the `GitHub repository <https://github.com/open-contracting/kingfisher-collect>`__ are in sync:

   .. code-block:: bash

      git checkout main
      git remote update
      git status

   The output should be exactly:

   .. code-block:: none

      On branch main
      Your branch is up to date with 'origin/main'.

      nothing to commit, working tree clean

#. Activate a virtual environment in which ``scrapyd-client`` is installed, and deploy the spiders:

   .. code-block:: bash

         scrapyd-deploy kingfisher

.. _kingfisher-collect-review-log-files:

Access Scrapyd's crawl logs
---------------------------

From a browser, click on a "Log" link from Scrapyd's `jobs page <https://collect.kingfisher.open-contracting.org/jobs>`__, or open the `logs page for the kingfisher project <https://collect.kingfisher.open-contracting.org/logs/kingfisher/>`__.

From the command-line, :ref:`connect to the server<connect-kingfisher-server>`, and change to the ``logs`` directory for the ``kingfisher`` project:

.. code-block:: bash

   curl --silent --connect-timeout 1 collect.kingfisher.open-contracting.org:8255 || true
   ssh ocdskfp@collect.kingfisher.open-contracting.org
   cd scrapyd/logs/kingfisher

Scrapy statistics are extracted from the end of each log file every hour on the hour, into a new file ending in ``.log.stats`` in the same directory as the log file. Access as above, or, from the `jobs page <https://collect.kingfisher.open-contracting.org/jobs>`__:

-  Right-click on a "Log" link.
-  Select "Copy Link" or similar.
-  Paste the URL into the address bar.
-  Change ``.log`` at the end of the URL to ``.log.stats`` and press Enter.

If you can't wait for the statistics to be extracted, you can connect to the server, replace ``spider_name/alpha-numeric-string``, and run:

.. code-block:: bash

   tac /home/ocdskfs/scrapyd/logs/kingfisher/spider_name/alpha-numeric-string.log | grep -B99 statscollectors | tac

If you are frequently running the above, `create an issue <https://github.com/open-contracting/deploy/issues>`__ to change the schedule.

.. _create-netrc-file:

Create a .netrc file
--------------------

To :ref:`collect data<collect-data>` with (and :ref:`update spiders<update-spiders>` in) Kingfisher Collect, you need to send requests to it from your computer as described above, using the same username (``scrape``) and password (ask a colleague) as to access https://collect.kingfisher.open-contracting.org in a web browser.

Instead of setting the username and password in multiple locations (on the command line and in ``scrapy.cfg`` files), set them in one location: in a ``.netrc`` file. In order to create (or append the Kingfisher Collect credentials to) a ``.netrc`` file, replace ``PASSWORD`` with the password, and run:

.. code-block:: bash

   echo 'machine collect.kingfisher.open-contracting.org login scrape password PASSWORD' >> ~/.netrc

You must change the file's permissions to be readable only by the owner:

.. code-block:: bash

   chmod 600 ~/.netrc

To check the permissions:

.. code-block:: shell-session

   $ stat -f "%Sp" ~/.netrc
   -rw-------

If you run ``grep collect.kingfisher.open-contracting.org ~/.netrc``, you should only see the single line you added with the correct password. If there are multiple lines or an incorrect password, you must correct the file in a text editor.

To test your configuration, run:

.. code-block:: bash

   curl -n https://collect.kingfisher.open-contracting.org/listprojects.json

You should see a response like:

.. code-block:: json

   {"node_name": "process1", "status": "ok", "projects": ["kingfisher"]}
