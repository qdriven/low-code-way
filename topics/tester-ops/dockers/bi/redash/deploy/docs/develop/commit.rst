Test and commit
===============

Test changes
------------

To preview what is going to change, use `test=True <https://docs.saltstack.com/en/latest/ref/states/testing.html>`__, for example:

.. code-block:: bash

   ./run.py 'docs' state.apply test=True

To preview changes to a Pillar file, run, for example:

.. code-block:: bash

   ./run.py 'docs' pillar.items

To compare Jinja2 output after refactoring but before committing, use ``script/diff`` to compare a full state or one SLS file, for example:

.. code-block:: bash

   ./script/diff docs
   ./script/diff docs zip

If you get the error, ``An Exception occurred while executing state.show_highstate: 'list' object has no attribute 'values'``, run ``state.apply test=True`` as above. You might have conflicting IDs.

Using a testing virtual host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To test changes to the Apache files for the :doc:`../reference/docs` (for example, to test new redirects or proxy settings):

#. Make changes inside ``{% if testing %}`` blocks in the config files
#. :doc:`Deploy<../deploy/deploy>` the OCDS Documentation
#. To test manually, visit the `testing version <https://testing.live.standard.open-contracting.org/>`__
#. To test automatically, run:

.. code-block:: bash

   pip install -r requirements.txt
   env FQDN=testing.live.standard.open-contracting.org pytest

Update the tests if you changed the behavior of the Apache files.

Once satisfied, move the changes outside ``{% if testing  %}`` blocks. After deployment, the tests should pass if ``FQDN`` is omitted or set to standard.open-contracting.org.

.. _using-a-virtual-machine:

Using a virtual machine
~~~~~~~~~~~~~~~~~~~~~~~

#. `Create a virtual machine <https://docs.saltstack.com/en/getstarted/ssh/system.html>`__
#. Get the virtual machine's IP address

   - If using VirtualBox, run (replacing ``VMNAME``):

     .. code-block:: bash

        VBoxManage guestproperty get VMNAME "/VirtualBox/GuestInfo/Net/0/V4/IP"

#. Update the relevant target in ``salt-config/roster`` to point to the virtual machine's IP address
#. In the relevant Pillar file, set ``https`` to ``False``
#. Edit ``/etc/hosts`` to map the virtual machine's IP address to the service's hostname
#. Deploy to the virtual machine and test

Note that Python errors that occur on the virtual machine might still be reported to Sentry. The ``server_name`` tag in any error reports is expected to be different, but the error reports might still confuse other developers who don't know to check that tag.

Review code
-----------

For context, for other repositories, work is done on a branch and tested on a local machine before a pull request is made, which is then tested on continuous integration, reviewed and approved before merging.

However, for this repository, in some cases, it's impossible to test changes to server configurations, for example: if SSL certificates are involved (without `additional configuration <https://github.com/icing/mod_md#ports-ports-ports>`__), or if external services are involved. In other cases, it's too much effort to setup a test environment in which to test changes.

In such cases, the same process is followed as in other repositories, but without the benefit of tests.

In entirely uncontroversial or time-sensitive cases, work is done on the default branch, deployed to servers, and committed to the default branch once successful. In cases where the changes require trial and error, the general approach is discussed in a GitHub issue, and then work is done on the default branch as above. Developers can always request informal reviews from colleagues.

Take extra care when making larger changes or when making changes to higher-priority services like the OCDS documentation, Data Review Tool or Kingfisher.
