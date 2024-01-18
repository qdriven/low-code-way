Learn Salt
==========

We use `Salt <https://docs.saltstack.com/en/latest/>`__ (a.k.a. SaltStack) to deploy apps to servers, and to otherwise manage servers.

We use `Agentless Salt <https://docs.saltstack.com/en/getstarted/ssh/index.html>`__ (i.e. using the ``salt-ssh`` command). This avoids having to run Salt minions on servers, and requires only SSH to connect to the server and Python to run operations on it.

To orient you to the repository: When you run the ``./run.py`` script, it calls the ``salt-ssh`` command, which reads ``Saltfile``, which directs it to read the ``salt-config`` directory. ``salt-config/master`` directs it to read the ``salt`` and ``pillar`` directories. The ``top.sls`` file in each directory serves as an index to the other SLS files, which in turn refer to the files in sub-directories.

Read the :doc:`style/index` before editing this repository.
