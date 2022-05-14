# https://github.com/saltstack-formulas/rsyslog-formula/blob/master/rsyslog/init.sls
rsyslog:
  service.running:
    - name: rsyslog
    - enable: True

{% if salt['pillar.get']('rsyslog:conf') %}
{% for filename, source in pillar.rsyslog.conf.items() %}
/etc/rsyslog.d/{{ filename }}:
  file.managed:
    - source: salt://core/rsyslog/files/{{ source }}
    - watch_in:
      - service: rsyslog
{% endfor %}
{% endif %}
