include:
  - apache
  - apache.modules.proxy

proxy_uwsgi:
  pkg.installed:
    - name: libapache2-mod-proxy-uwsgi
  apache_module.enabled:
    - require:
      - pkg: proxy_uwsgi
    - watch_in:
      - service: apache2
