Bash shell
==========

.. _tmux:

Perform a long-running task
---------------------------

If a task will take a long time to run, run it in a terminal multiplexer (``tmux``), in case you lose your connection to the server. To open a session in ``tmux``, use this command, replacing ``initials-task-description`` with your initials and a short description of your task. By including your initials, it is easy for others to determine to whom the session belongs – especially if you forget to close it.

.. code-block:: bash

   tmux new -s initials-task-description

If you lose your connection to the server, re-attach to your session with:

.. code-block:: bash

   tmux attach-session -t initials-task-description

To manually detach from a session, press ``Ctrl-b``, release both keys, then press ``d``.

If you forget the name of your session, list all sessions with:

.. code-block:: bash

   tmux ls
