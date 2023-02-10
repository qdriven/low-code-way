# Stop RemoveIPC killing all processes by a user when they log out.

/etc/systemd/logind.conf:
  file.replace:
    - pattern: "#?RemoveIPC=yes"
    - repl: "RemoveIPC=no"
    - append_if_not_found: True
