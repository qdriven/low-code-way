include:
  - apache

rewrite:
  apache_module.enabled:
    - watch_in:
      - service: apache2
