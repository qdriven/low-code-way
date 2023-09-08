# We'll only be using SSH key authentication.
disable password authentication:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "^#?PasswordAuthentication .*"
    - repl: PasswordAuthentication no

# The above "PasswordAuthentication no" technically disables root logins with passwords but we are explicitly setting "PermitRootLogin" as well for two reasons:
# Firstly it adds an extra layer to the security if PasswordAuthentication is toggled back on.
# Secondly while PermitRootLogin is set to either "no" or "without-password" we can monitor it with our intrusion detection software.
force root ssh keys:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "^#?PermitRootLogin.*"
    - repl: "PermitRootLogin without-password"

disable x11forwarding:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "^#?X11Forwarding yes"
    - repl: "X11Forwarding no"

# Restart the SSH service if the config changes.
ssh_service:
  service.running:
    - name: ssh
    - enable: True
    - reload: True
    - listen:
      - file: /etc/ssh/sshd_config

# Manage authorized keys for users with root access to all servers.
root_authorized_keys:
  ssh_auth.manage:
    - user: root
    - ssh_keys: {{ (pillar.ssh.admin + salt['pillar.get']('ssh:root', []))|yaml }}
