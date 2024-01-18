# Some configurations use `postrotate /usr/lib/rsyslog/rsyslog-rotate`, so rsyslog is required.
include:
  - core.rsyslog

{% if salt['pillar.get']('logrotate:conf') %}
{% for filename, source in pillar.logrotate.conf.items() %}
/etc/logrotate.d/{{ filename }}:
  file.managed:
    - source: salt://core/logrotate/files/{{ source }}
{% endfor %}
{% endif %}
