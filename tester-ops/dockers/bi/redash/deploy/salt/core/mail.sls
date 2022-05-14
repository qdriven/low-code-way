# Install and configure email software.
postfix:
  pkg.installed:
    - name: postfix
    - require:
      - debconf: postfix
  service.running:
    - name: postfix
    - enable: True
    - require:
      - pkg: postfix
  debconf.set:
    - data:
        # I don't expect FQDN to ever be unset but if it is, fallback to /etc/mailname.
        'postfix/mailname': {'type': 'string', 'value': {{ salt['grains.get']('fqdn', '/etc/mailname') }} }
        # "Internet Site" means mail is sent and received directly using SMTP.
        'postfix/main_mailer_type': { 'type' : 'select', 'value' : 'Internet Site' }
    - require:
      - pkg: debconf-utils
  cmd.run:
    - name: dpkg-reconfigure -f noninteractive postfix
    - require:
      - pkg: postfix
    - onchanges:
      - debconf: postfix

# Install commands for users to interact with mail.
mailutils:
  pkg.installed

# Configure /etc/aliases.
root:
  alias.present:
    - target: {{ pillar.system_contacts.root }}
admin:
  alias.present:
    - target: root
postmaster:
  alias.present:
    - target: root

# Set up root crontab email.
MAILTO_root:
  cron.env_present:
    - name: MAILTO
    - value: {{ pillar.system_contacts.cron_admin }}
    - user: root
