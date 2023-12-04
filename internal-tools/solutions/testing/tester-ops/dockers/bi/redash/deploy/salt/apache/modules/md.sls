include:
  - apache

# mod_md 2.2 is in at least Apache 2.4.42.
# mod_watchdog is part of the server and not a module.
# https://downloads.apache.org/httpd/CHANGES_2.4
# https://github.com/icing/mod_md#versions-and-releases
md:
  apache_module.enabled:
    - watch_in:
      - service: apache2
