Language style guides
=====================

Jinja templating language
-------------------------

Use dot notation:

.. code-block:: jinja

   {{ pillar.host_id }}
   {{ grains.kernel }}

**AVOID** bracket notation:

.. code-block:: jinja

   {{ pillar['host_id'] }}  # AVOID
   {{ grains['kernel'] }}  # AVOID

.. note::

   To allow the use of dot notation in Jinja, prefer underscores to hyphens in Pillar keys.

To test whether a mapping key is present, use the ``in`` operator:

.. code-block:: jinja

   {% if 'child' in pillar.parent %}

To test whether an optional boolean is true, use the ``.get()`` method:

.. code-block:: jinja

   {% if pillar.parent.get('enabled') %}

If a Pillar key might not be set, use ``.get()``:

.. code-block:: jinja

   {{ pillar.parent.get('child') }}

If many parts of a Pillar key might not be set, use ``salt['pillar.get']()``:

.. code-block:: jinja

   {{ salt['pillar.get']('parent:child') }}

Note the colon (``:``) between ``parent`` and ``child``.

YAML data-serialization language
--------------------------------

Capitalize the ``True`` and ``False`` booleans, for consistency.

Avoid gotchas
~~~~~~~~~~~~~

-  If unquoted, ``yes``, ``no``, ``True`` and ``False`` are parsed as booleans in YAML. Use quotes to parse as strings.
-  A blank value is parsed as ``None`` in YAML. Use the empty string ``''`` to parse as a string.

For example, in the Jinja snippet below, if ``a`` is equal to an empty string, then ``b`` will be ``None``:

.. code-block:: jinja

   {% set extracontext %}
   b: {{ a }}
   {% endset %}

Instead, surround it in quotes:

.. code-block:: jinja

   {% set extracontext %}
   b: "{{ a }}"
   {% endset %}
