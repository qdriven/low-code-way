Maintain Elasticsearch
======================

Troubleshoot
------------

Check the ``/var/log/elasticsearch/elasticsearch.log`` and ``/var/log/elasticsearch/elasticsearch_server.json`` log files for non-INFO messages:

.. code-block:: bash

   grep -v INFO /var/log/elasticsearch/elasticsearch.log /var/log/elasticsearch/elasticsearch_server.json

Check the log files in the ``/var/log/elasticsearch`` directory, including:

-  ``elasticsearch_deprecation.log``
-  ``elasticsearch_deprecation.json``

Errors are logged in ``/var/log/elasticsearch/elasticsearch.log``, for example:

-  "All shards failed for phase: [query]", often followed by:

   -  Failed to parse query [*query*]
   -  Cannot parse '*query*'
   -  Failed to execute [SearchRequest{ … "query":"*query*" … }]

.. note::

   ``/etc/elasticsearch/log4j2.properties`` configures a log file rotation strategy of:

   .. code-block:: none

      appender.rolling.strategy.action.condition.nested_condition.type = IfAccumulatedFileSize
      appender.rolling.strategy.action.condition.nested_condition.exceeds = 2GB

   To change to a `7-day rotation strategy <https://www.elastic.co/guide/en/elasticsearch/reference/7.10/logging.html>`__, update this repository to replace this with:

   .. code-block:: none

      appender.rolling.strategy.action.condition.nested_condition.type = IfLastModified
      appender.rolling.strategy.action.condition.nested_condition.age = 7D

Manage data
-----------

.. admonition:: One-time setup

   Set the password of the ``manage`` user in a netrc file, replacing ``PASSWORD``:

   .. code-block:: bash

      echo 'machine standard.open-contracting.org login manage password PASSWORD' >> ~/.netrc

List indices:

.. code-block:: bash

   curl -n https://standard.open-contracting.org:9200/_cat/indices

List base URLs in a given index, for example:

.. code-block:: bash

   curl -n -X GET 'https://standard.open-contracting.org:9200/ocdsindex_en/_search?size=0&pretty' \
   -H 'Content-Type: application/json' \
   -d '{"aggs": {"base_urls": {"terms": {"field": "base_url", "size": 10000}}}}'

Delete documents matching a base URL:

.. code-block:: bash

   curl -n -X POST 'https://standard.open-contracting.org:9200/ocdsindex_en/_delete_by_query' \
   -H 'Content-Type: application/json' \
   -d '{"query": {"term": {"base_url": "https://standard.open-contracting.org/staging/1.1-dev/"}}}'

Expire documents using `OCDS Index <https://github.com/open-contracting/ocds-index>`__:

.. code-block:: bash

   ocdsindex expire https://standard.open-contracting.org:9200 --exclude-file=ocdsindex-exclude.txt

Search documents in a given index matching a base URL, for example:

.. code-block:: bash

   curl -n -X GET 'https://standard.open-contracting.org:9200/ocdsindex_en/_search?size=10000' \
   -H 'Content-Type: application/json' \
   -d '{"query": {"term": {"base_url": "https://standard.open-contracting.org/staging/1.1-dev/"}}}'

List users' queries:

.. code-block:: bash

   zgrep -Eoh "q=[^&]+&" /var/log/apache2/* | grep -v '=test&' | grep -v '=tender&' | sort

Upgrade
-------

If the `ReadOnlyREST plugin <https://readonlyrest.com>`__ is used:

#. Get the ReadOnlyREST plugin's ZIP file:

   #. Open the `download page <https://readonlyrest.com/download/>`__
   #. Select "Free Elasticsearch plugin" from the *Select Product* dropdown
   #. Select the Elasticsearch version from the *Elastic Stack Version* dropdown
   #. Enter your email address in *Send to email*
   #. Check *Notify me about new versions and security fixes*
   #. Click the *Get it now* button

   .. note::

      A new version might not yet be available for download. You can check the `changelog <https://github.com/beshu-tech/readonlyrest-docs/blob/master/changelog.md>`__.

#. Move the ZIP file to the ``salt/private/files`` directory.

#. Stop Elasticsearch, for example:

   .. code-block:: bash

      ./run.py 'docs' service.stop elasticsearch

#. Uninstall ReadOnlyREST, for example:

   .. code-block:: bash

      ./run.py 'docs' cmd.run "/usr/share/elasticsearch/bin/elasticsearch-plugin remove readonlyrest"

#. Update ``readonlyrest_version`` and ``source_hash`` in the ``salt/elasticsearch/plugins/readonlyrest.sls`` file

#. :doc:`Deploy the service<../deploy/deploy>`

Reference: `Upgrading the plugin <https://github.com/beshu-tech/readonlyrest-docs/blob/master/elasticsearch.md#upgrading-the-plugin>`__
