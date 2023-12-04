include:
  - apache

http2:
  apache_module.enabled:
    - watch_in:
      - service: apache2
