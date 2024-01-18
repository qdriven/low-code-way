# Disable pre-installed systemd-timesyncd as we prefer NTP.
systemd-timesyncd:
  service.dead:
    - enable: False

ntp:
  pkg.installed:
    - name: ntp
  service.running:
    - name: ntp
    - enable: True
    - require:
      - pkg: ntp

/etc/ntp.conf:
  file.replace:
    - pattern: "ubuntu.pool.ntp.org"
    - repl: "uk.pool.ntp.org"
    - require:
      - pkg: ntp
    - watch_in:
      - service: ntp

# Set timezone to UTC.
UTC:
  timezone.system
