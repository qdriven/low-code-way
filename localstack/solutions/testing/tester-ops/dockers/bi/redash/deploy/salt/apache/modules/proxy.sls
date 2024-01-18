include:
  - apache

proxy:
  apache_module.enabled:
    - watch_in:
      - service: apache2
