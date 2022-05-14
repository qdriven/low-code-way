# Expects an additional argument defining the server hostname. Example:
#
#   salt-ssh 'example' state.apply 'onboarding,core*' pillar='{"host_id":"ocpXX"}'
#
# `order` is used, to ensure these states run before any core states.

update all packages:
  pkg.uptodate:
    - order: 1
    - refresh: True
    - dist_upgrade: True

{%- if 'fqdn_ip4' in grains %}
{{ grains.fqdn_ip4[0] }}:
  host.only:
    - order: 2
    - hostnames:
      - {{ pillar.host_id }}.open-contracting.org
      - {{ pillar.host_id }}
{% endif %}
{%- if 'fqdn_ip6' in grains %}
{{ grains.fqdn_ip6[0] }}:
  host.only:
    - order: 2
    - hostnames:
      - {{ pillar.host_id }}.open-contracting.org
      - {{ pillar.host_id }}
{% endif %}

/etc/mailname:
  file.managed:
    - order: 3
    - contents: "{{ pillar.host_id }}.open-contracting.org"

set hostname:
  network.system:
    - order: 4
    - enabled: True
    - hostname: "{{ pillar.host_id }}"
    - apply_hostname: True
