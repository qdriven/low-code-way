# "Executable scripts in /etc/update-motd.d/* are executed by pam_motd(8) as the root user at each login."
# https://manpages.ubuntu.com/manpages/hirsute/en/man5/update-motd.5.html
disable default motds:
  file.managed:
    - names:
      - /etc/update-motd.d/10-help-text
      - /etc/update-motd.d/80-livepatch
    - mode: 644

/etc/default/motd-news:
  file.replace:
    - pattern: "^ENABLED=.*"
    - repl: ENABLED=0
    - ignore_if_missing: True
