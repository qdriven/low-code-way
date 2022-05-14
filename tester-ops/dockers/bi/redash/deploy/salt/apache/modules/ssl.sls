include:
  - apache

ssl:
  apache_module.enabled:
    - watch_in:
      - service: apache2
