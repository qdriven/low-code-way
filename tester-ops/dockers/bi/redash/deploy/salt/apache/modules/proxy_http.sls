include:
  - apache
  - apache.modules.proxy

proxy_http:
  apache_module.enabled:
    - watch_in:
      - service: apache2
