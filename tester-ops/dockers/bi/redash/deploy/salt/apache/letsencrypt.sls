include:
  - apache
  - apache.modules.http2
  - apache.modules.md
  - apache.modules.ssl

/etc/apache2/conf-available/letsencrypt.conf:
  file.managed:
    - source: salt://apache/files/conf/letsencrypt.conf
    - template: jinja
    - require:
      - pkg: apache2
    - watch_in:
      - module: apache2-reload

enable-letsencrypt-conf:
  apache_conf.enabled:
    - name: letsencrypt
    - require:
      - file: /etc/apache2/conf-available/letsencrypt.conf
    - watch_in:
      - module: apache2-reload
