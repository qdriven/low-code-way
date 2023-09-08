include:
  - apache

remoteip:
  apache_module.enabled:
    - watch_in:
      - service: apache2
