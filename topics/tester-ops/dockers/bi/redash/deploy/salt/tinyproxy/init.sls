{% from 'lib.sls' import set_firewall %}

{{ set_firewall("PUBLIC_TINYPROXY") }}

tinyproxy:
  pkg.installed:
    - name: tinyproxy
  service.running:
    - name: tinyproxy
    - enable: True
    - restart: True
    - require:
      - pkg: tinyproxy

/etc/tinyproxy/tinyproxy.conf:
  file.managed:
    - source: salt://tinyproxy/files/tinyproxy.conf
    - template: jinja
    - makedirs: True
    - watch_in:
      - service: tinyproxy
