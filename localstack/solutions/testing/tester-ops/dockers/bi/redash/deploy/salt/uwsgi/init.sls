uwsgi:
  pkg.installed:
    - pkgs:
      - uwsgi
      - uwsgi-plugin-python3
  service.running:
    - name: uwsgi
    - enable: True
    - reload: True
    - require:
      - pkg: uwsgi
