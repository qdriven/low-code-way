redis:
  pkg.installed:
    - name: redis-server
  service.running:
    - name: redis-server
    - enable: True
    - require:
      - pkg: redis
