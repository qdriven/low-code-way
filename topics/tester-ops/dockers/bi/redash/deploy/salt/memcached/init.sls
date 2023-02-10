memcached:
  pkg.installed:
    - name: memcached
  service.running:
    - name: memcached
    - enable: True
    - require:
      - pkg: memcached
