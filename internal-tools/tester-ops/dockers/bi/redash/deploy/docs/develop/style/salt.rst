Salt style guide
================

Read `Salt Best Practices <https://docs.saltstack.com/en/latest/topics/best_practices.html>`__ and `Salt Formulas Style <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#style>`__.

State IDs
---------

While state IDs with spaces are easier to read, they are also easier to mistype: for example, in ``require`` arguments. As such, prefer hyphens to spaces in state IDs.

State functions
---------------

cmd
~~~

In general, avoid the `cmd.run <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.cmd.html>`__ function. For most system commands, Salt provides a `state function <https://docs.saltstack.com/en/latest/ref/states/all/index.html>`__.

Our use is limited to:

-  Activating and running a Python command within a virtual environment
-  Running a custom script that is specific to our services
-  Running a system command for which Salt has no relevant function (rare)

Excluding virtual environments, ``cmd.run`` is used less than 10 times in the repository.

When using ``cmd.run``, you should set an ``onchanges`` requisite or a ``creates`` argument. Otherwise, a ``cmd.run`` function is run each time its state file is applied.

file
~~~~

If possible, avoid `file <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.file.html>`__ functions. For many system files, Salt provides a `state function <https://docs.saltstack.com/en/latest/ref/states/all/index.html>`__.

Our use is limited to:

-  Writing a custom file or creating a custom directory that is specific to our services
-  Updating a system file for which Salt has no relevant function (uncommon)

Note that unarchiving files (whether local or remote) should use the `archive.extracted function <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.archive.html>`__.

.. warning::

   If ``skip_verify`` is ``True`` and the ``source`` is remote, then the file will `never be updated <https://github.com/saltstack/salt/issues/58961>`__. Use ``source_hash``, instead.

.. _service-functions:

service
~~~~~~~

The Salt documentation `states <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.service.html>`__:

   By default if a service is triggered to refresh due to a watch statement the service is restarted. If the desired behavior is to reload the service, then set the reload value to True.

Some configuration changes require a reload only, while others require a restart. To support both, we author IDs like:

.. code-block:: yaml

   apache2:
     service.running:
       - name: apache2
       - enable: True

   apache2-reload:
     module.wait:
       - name: service.reload
       - m_name: apache2

   proxy:
     apache_module.enabled:
       - name: proxy
       - watch_in:
         - service: apache2

   enable-letsencrypt-conf:
     apache_conf.enabled:
       - name: letsencrypt
       - watch_in:
         - module: apache2-reload

In this example, enabling the ``proxy`` module causes the ``apache2`` service to restart, whereas enabling the ``letsencrypt`` configuration causes it to reload.

Includes
--------

As the Salt documentation `states <https://docs.saltstack.com/en/getstarted/config/include.html>`__, with respect to whether to use an include or the top file:

   If a Salt state always needs some other state, then using an include is a better choice. If only some systems should receive both Salt states, including both states in the top file gives you the flexibility to choose which systems receive each.

In other words: If running ``state.apply my-state`` fails with an error like:

.. code-block:: none

   - Cannot extend ID 'my-id' in 'base:my-state'. It is not part of the high state.
     This is likely due to a missing include statement or an incorrectly typed ID.
     Ensure that a state with an ID of 'my-id' is available
     in environment 'base' and to SLS 'my-state'

then the state file that defines the ``my-id`` ID should be included in the ``my-state`` file. Otherwise, it shouldn't.

Requisites
----------

Instead of relying on `ordering <https://docs.saltstack.com/en/getstarted/config/requisites.html>`__, it's better to explicitly declare direct `requisites <https://docs.saltstack.com/en/latest/ref/states/requisites.html>`__. We use exclusively:

-  `require <https://docs.saltstack.com/en/latest/ref/states/requisites.html#require>`__ is easier to reason about than ``require_in``, because code typically declares its own dependencies.
-  `watch_in <https://docs.saltstack.com/en/latest/ref/states/requisites.html#watch>`__  is easier to reason about than ``watch``, because it follows the direction of causation: if *this* state changes, then :ref:`restart or reload<service-functions>` *that* service.
-  `onchanges <https://docs.saltstack.com/en/latest/ref/states/requisites.html#onchanges>`__ makes the state apply only if its required state generates changes, and is used exclusively with the ``cmd.run`` function (which otherwise always applies).

We use ``require_in`` in exceptional circumstances: for example, to require a state created by a macro.

Macros
------

As the Salt documentation `states <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#jinja-macros>`__:

   Jinja macros are useful for one thing and one thing only: creating mini templates that can be reused and rendered on demand.

All macros are defined in `lib.sls <https://github.com/open-contracting/deploy/blob/main/salt/lib.sls>`__.

-  :doc:`set_firewall() and unset_firewall()<../update/firewall>` make sense as macros, because different state files might want to open or close different ports based on Pillar data. For example, the ``apache`` file opens or closes ports 80 and 443 based on the ``apache.public_access`` value.
-  ``create_user()`` makes sense as a macro, because users are created in many different contexts, and it is simpler to couple the user's creation to that context, than to synchronize user creation and service configuration in separate places.
-  ``apache()`` makes sense as a macro, because sites are created in two different contexts: when processing ``apache.sites`` data in the ``apache`` file, and ``python_apps`` data in the ``python`` file. See `#80 <https://github.com/open-contracting/deploy/issues/80#issuecomment-739122716>`__.

Looping over Pillar data
------------------------

A few state files loop over Pillar data:

-  :doc:`core.rsyslog and core.logrotate<../update/logs>`
-  :doc:`apache<../update/apache>`, included by the top file if the ``apache.sites`` key is set in Pillar data
-  :doc:`python_apps<../update/python>`, included by the state files of specific services
-  ``prometheus``, included by the state file of the ``prometheus`` service, and by non-development targets in the top file

This pattern allows service-specific configuration values to live in Pillar, rather than in Salt.
