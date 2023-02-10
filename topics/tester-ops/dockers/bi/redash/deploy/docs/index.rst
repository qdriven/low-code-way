Deploy
======

This documentation is split into:

:doc:`Development Guides<develop/index>`
   Instructions on getting set-up and making changes to the ``deploy`` repository.
:doc:`Deployment Guides<deploy/index>`
   Instructions for specific deployment tasks.
:doc:`Maintenance Guides<maintain/index>`
   Instructions for specific maintenance tasks.
:doc:`User Guides<use/index>`
   Documentation for users of our services.
:doc:`Reference<reference/index>`
   Infrequently accessed reference material.

Development Guides
------------------

Follow the :doc:`develop/get_started` guide before following any of the :doc:`deploy/index`. If you're new to Salt, :doc:`develop/learn`.

To make changes to the `deploy repository <https://github.com/open-contracting/deploy>`__, read the :doc:`develop/update/index` and following guides.

.. toctree::
   :maxdepth: 2

   develop/index.rst

Deployment Guides
-----------------

If you need to perform a specific deployment task, follow the relevant how-to guide. This section focuses on deploying the changes you made in the previous section.

All changes to servers should be made using Salt to ensure that changes are documented and reproducible; changes should not be made manually, which is undocumented and error-prone.

.. toctree::
   :maxdepth: 2

   deploy/index.rst

Maintenance Guides
------------------

This section describes how to perform tasks that don't involve changes in Salt.

.. toctree::
   :maxdepth: 2

   maintain/index.rst

User Guides
-----------

This section contains documentation specific to our deployment of a given service. For generic documentation of a given service that we authored, follow the *Docs* links on `this page <https://github.com/open-contracting/standard-maintenance-scripts/blob/main/badges.md#tools>`__.

.. toctree::
   :maxdepth: 2

   use/index.rst

Reference
---------

This section describes facts about our servers and deployments.

.. toctree::
   :maxdepth: 2

   reference/index.rst
