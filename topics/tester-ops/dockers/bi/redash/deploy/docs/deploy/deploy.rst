Deploy a service
================

As with other deployment tasks, do the :ref:`setup tasks<generic-setup>` before (and the :ref:`cleanup tasks<generic-cleanup>` after) the steps below. If you run into trouble, read the :doc:`troubleshoot` guide.

1. Run Salt function
--------------------

To deploy a service, indicate the desired target and the ``state.apply`` function, for example:

.. code-block:: bash

    ./run.py 'docs' state.apply

To limit the output to changes and failures, add a ``--state-output=changes option``, for example:

.. code-block:: bash

    ./run.py --state-output=changes option 'docs' state.apply

To `run a specific state file <https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.state.html#salt.modules.state.sls>`__, run, for example:

.. code-block:: bash

   ./run.py 'docs' state.sls elasticsearch

To `run a specific SLS ID <https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.state.html#salt.modules.state.sls_id>`__, run, for example:

.. code-block:: bash

   ./run.py '*' state.sls_id root_authorized_keys core.sshd

If the output has an error of ``Unable to detect Python-2 version``, you don't have Python 2.7 in your PATH. To fix this, if you use ``pyenv``, run, for example:

.. code-block:: bash

    pyenv shell system

The ``state.apply`` function often completes within one minute. You can ignore this warning: ``DeprecationWarning: encoding is deprecated, Use raw=False instead``.

.. note::

   If you want to check whether a deployment is simply slow (frequent) or actually stalled (rare), :ref:`watch Salt's activity<watch-salt-activity>`.

2. Check Salt output
--------------------

Look for these lines at the end of the output in the primary terminal:

.. code-block:: none

    Summary for docs
    -------------
    Succeeded: ## (changed=#)
    Failed:     0

Then:

#. Check that the app is still responding in your web browser.
#. If there are any failed states, look for each in the output (red text) (or search for ``Result: False``) and debug.
#. If there are any changed states, look for each in the output (blue text) (or grep for ``Changes:   \n[^\n-]``) and verify the changes.

Common changed states are:

Function: service.running, ID: apache2
  Apache was reloaded

For a Django app, common changed states are:

Function: git.latest
  A new commit was deployed
Function: cmd.run, Name: . .ve/bin/activate; pip-sync -q --pip-args "--exists-action w"
  Requirements were installed
Function: cmd.run, Name: . .ve/bin/activate; DJANGO_SETTINGS_MODULE=... python manage.py migrate --noinput
  Django migrations were applied
Function: cmd.run, Name: . .ve/bin/activate; DJANGO_SETTINGS_MODULE=... python manage.py compilemessages
  Message catalogs were compiled
Function: cmd.run, Name: . .ve/bin/activate; DJANGO_SETTINGS_MODULE=... python manage.py collectstatic --noinput
  Static files were collected
Function: service.running, ID: uwsgi
  uWSGI was reloaded

States that always report changes:

-  `cmd.run <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.cmd.html>`__, unless ``onchanges`` is specified
-  `pip.installed <https://github.com/saltstack/salt/issues/24216>`__, if ``upgrade`` is set
-  ``postgres_privileges.present``, if ``object_name`` is ``ALL``

3. Manual cleanup
-----------------

If you changed the server name of a virtual host that uses HTTPS, you will need to :ref:`ssl-certificates` for the new server name.

If you :doc:`removed a Salt configuration<../develop/update/delete>`, follow the linked steps to cleanup manually.
