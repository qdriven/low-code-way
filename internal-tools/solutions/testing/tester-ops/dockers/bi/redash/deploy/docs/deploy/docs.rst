OCDS documentation tasks
========================

Add a new language
------------------

#. In ``salt/apache/files/sites/docs.conf.include``, add the new language in the ``options`` variable.
#. In ``tests/test_docs.py``, update the ``languages`` variable.

.. _add-new-profile:

Add a new profile
-----------------

Below, substitute ``{root}``, ``{latest-branch}``, ``{minor-branch}`` and ``{dev-branch}``. For example: ``ppp``, ``latest`` ``1.0`` and ``1.0-dev``.

#. Edit ``salt/docs/robots.txt``
#. For Googlebot, add:

   .. code-block:: none

      Allow: /profiles/{root}/{latest-branch}

#. If the profile publishes schema files, also add:

   .. code-block:: none

      Allow: /profiles/{root}/schema
      Allow: /profiles/{root}/extension

#. If the profile has a single branch, skip these steps. Otherwise, for all user agents, add:

   .. code-block:: none

      Disallow: /profiles/{root}/{minor-branch}
      Disallow: /profiles/{root}/{dev-branch}

#. If the profile has older versions, also add, for each ``{old-version}``:

   .. code-block:: none

      Disallow: /profiles/{root}/{old-branch}

.. _publish-draft-documentation:

Publish draft documentation
---------------------------

To configure a documentation repository to push builds to the server:

#. Access the repository’s *Settings* tab
#. Click *Secrets*
#. Set the private key:

   #. Click *New repository secret*
   #. Set *Name* to "PRIVATE_KEY"
   #. Set *Value* to the contents of ``salt/private/keys/docs_ci``
   #. Click *Add secret*

#. Set the Elasticsearch password:

   #. Click *New repository secret*
   #. Set *Name* to "ELASTICSEARCH_PASSWORD"
   #. Set *Value* to the password of the ``manage`` user in the ``pillar/private/docs.sls`` file
   #. Click *Add secret*

.. _publish-released-documentation:

Publish released documentation
------------------------------

1. Update the documentation repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Follow the OCDS Development Handbook's `deployment guide <https://ocds-standard-development-handbook.readthedocs.io/en/latest/standard/technical/deployment.html>`__.

If this is the first numbered version of a profile, in its ``docs/_templates/layout.html``, add (substituting ``{root}`` with ``ppp``, for example):

.. code-block:: jinja

   {% block version_options %}
   <!--#include virtual="/includes/version-options-profiles-{root}.html" -->
   {% endblock %}

In any case, once the `build passes <https://ocds-standard-development-handbook.readthedocs.io/en/latest/standard/technical/deployment.html#build>`__ for the live branch of the documentation:

2. Copy the files to the server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. admonition:: One-time setup

   Set the password of the ``manage`` user in a netrc file, replacing ``PASSWORD``:

   .. code-block:: bash

      echo 'machine standard.open-contracting.org login manage password PASSWORD' >> ~/.netrc

The build of the live branch is copied from the staging directory to the live directory, as a build directory named ``branch-date-sequence``, for example: ``1.1-2017-08-08-2``. A symlink named ``branch`` points to the build directory. As such, you can rollback by pointing to another build directory.

Set environment variables, for example:

.. code-block:: bash

   SUBDIR=          # include a trailing slash (leave empty for OCDS documentation)
   VER=1.1          # set to the branch to deploy (not to the tag)
   DATE=$(date +%F) # assuming the build completed today; otherwise, set accordingly
   SEQ=1            # increment for each deploy on the same day

For a profile, set ``SUBDIR`` to, for example, ``profiles/ppp/``. For OC4IDS, set it to ``infrastructure/``.

Copy files from the staging directory to the live directory:

.. code-block:: bash

   curl --silent --connect-timeout 1 standard.open-contracting.org:8255 || true
   ssh root@standard.open-contracting.org "rsync -az /home/ocds-docs/web/staging/${SUBDIR}${VER}/ /home/ocds-docs/web/${SUBDIR}${VER}-${DATE}-${SEQ}"

Update the symlink:

.. code-block:: bash

   curl --silent --connect-timeout 1 standard.open-contracting.org:8255 || true
   ssh root@standard.open-contracting.org "ln -nfs ${VER}-${DATE}-${SEQ} /home/ocds-docs/web/${SUBDIR}${VER}"

Copy the documents in Elasticsearch from the staging base URL to the production base URL:

.. code-block:: bash

   ocdsindex copy https://standard.open-contracting.org:9200 https://standard.open-contracting.org/staging/${SUBDIR}${VER}/ https://standard.open-contracting.org/${SUBDIR}${VER}/

If the branch is for the latest version of the documentation, repeat this step with ``VER=latest``.

3. Copy the schema and ZIP file into place
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

   You can skip this step if you are not releasing a new major, minor or patch version.

Connect to the server:

.. code-block:: bash

   curl --silent --connect-timeout 1 standard.open-contracting.org:8255 || true
   ssh root@standard.open-contracting.org

Set environment variables, for example:

.. code-block:: bash

   SUBDIR=          # include a trailing slash (leave empty for OCDS documentation)
   VER=1.1          # set to the branch as above
   RELEASE=1__1__1  # set to the full release tag name

For a profile, set ``SUBDIR`` to, for example, ``profiles/ppp/``. For OC4IDS, set it to ``infrastructure/``.

For the **OCDS** and **OC4IDS** documentation, run:

.. code-block:: bash

   # Create the directory for the release.
   mkdir /home/ocds-docs/web/${SUBDIR}schema/${RELEASE}/

   # Copy the schema and codelist files.
   cp -r /home/ocds-docs/web/${SUBDIR}${VER}/en/*.json /home/ocds-docs/web/${SUBDIR}schema/${RELEASE}/
   cp -r /home/ocds-docs/web/${SUBDIR}${VER}/en/codelists /home/ocds-docs/web/${SUBDIR}schema/${RELEASE}/

   # Create a ZIP file of the above.
   cd /home/ocds-docs/web/${SUBDIR}schema/
   zip -r ${RELEASE}.zip ${RELEASE}

The files are then visible at e.g. https://standard.open-contracting.org/schema/1__1__1/.

For a **profile's** documentation, run:

.. code-block:: bash

   # Create the profile and patched directories for the release.
   mkdir -p /home/ocds-docs/web/${SUBDIR}extension/${RELEASE}/ /home/ocds-docs/web/${SUBDIR}schema/${RELEASE}/

   # Copy the profile's schema and codelist files.
   cp -r /home/ocds-docs/web/${SUBDIR}${VER}/en/*.json /home/ocds-docs/web/${SUBDIR}extension/${RELEASE}/
   cp -r /home/ocds-docs/web/${SUBDIR}${VER}/en/codelists /home/ocds-docs/web/${SUBDIR}extension/${RELEASE}/

   # Create a ZIP file of the above.
   cd /home/ocds-docs/web/${SUBDIR}extension/
   zip -r ${RELEASE}.zip ${RELEASE}

   # Copy the patched schema and codelist files.
   cp -r /home/ocds-docs/web/${SUBDIR}${VER}/en/_static/patched/* /home/ocds-docs/web/${SUBDIR}schema/${RELEASE}/

4. Update this repository
~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::
   You can skip this step if you are not releasing a new major, minor or patch version.

Below, substitute ``{root}``, ``{latest-branch}``, ``{dev-branch}``, ``{formatted-dev-branch}``, ``{version}`` and ``{name}``. For example: ``ppp``, ``latest``, ``1.0-dev``, ``1.0 Dev``, ``1.0.0.beta`` and ``OCDS for PPPs``.

If this is the first numbered version of a profile:

#. :ref:`Update salt/docs/robots.txt<add-new-profile>`.
#. In ``salt/apache/files/sites/docs.conf.include``, add the profile's latest branch, minor series and languages in the ``options`` variable.
#. In ``tests/test_docs.py``, update the ``versions``, ``languages`` and ``banner_live`` variables.
#. Add a ``salt/docs/includes/version-options-profiles-{root}.html`` file to this repository:

   .. code-block:: html

      <option>Version</option>
      <option value="{latest-branch}">{version} ({latest-branch})</option>

#. Add a ``salt/docs/includes/banner_staging_profiles_{root}.html`` file to this repository:

   .. code-block:: html

      <div class="oc-fixed-alert-header">
          This is a development copy of the {name} docs, the <a href="/profiles/{root}/{latest-branch}/en/">latest live version is here</a>.
      </div>

Otherwise:

#. In the appropriate ``salt/docs/includes/version-options*.html`` file, update the version number in the text of the first ``option`` element.

If this is a new major or minor version:

#. In ``salt/docs/robots.txt``, disallow the minor branch and its dev branch, for example:

   .. code-block:: none

      Disallow: /1.2
      Disallow: /1.2-dev

#. In ``salt/apache/files/sites/docs.conf.include``, add the minor series in the ``options`` variable, and add a new ``Location`` directive like:

   .. code-block:: apache

      <Location /1.1/>
          SetEnv BANNER /includes/banner_old.html
      </Location>

#. In ``ocdsindex-exclude.txt``, add the base URL of the new version.
#. In ``tests/test_docs.py``, update the ``versions``, ``banner_live`` and ``banner_old`` variables.
#. In the appropriate ``salt/docs/includes/banner_staging*.html`` file and ``salt/docs/includes/banner_old*.html>`` file (if any), update the minor series.
#. In the appropriate ``salt/docs/includes/version-options*.html`` file, add an ``option`` element to the "Live" ``optgroup`` for the previous minor series and previous version number, for example:

   .. code-block:: html

      <option value="0.9">0.9.2</option>

5. Update other repositories
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Update the Data Review Tool <https://ocds-standard-development-handbook.readthedocs.io/en/latest/standard/technical/deployment.html#update-the-data-review-tool>`__ and any other tools per `this spreadsheet <https://docs.google.com/spreadsheets/d/18Pq5Hyyk4bNQ_mIaCRqGqwut4ws2_cIh0UYQNAYKv-A/edit#gid=0>`__. (See `sample CRM issue <https://crm.open-contracting.org/issues/4580>`__.)
