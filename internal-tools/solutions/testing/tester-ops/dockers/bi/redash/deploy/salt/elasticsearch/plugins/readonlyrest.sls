# https://github.com/beshu-tech/readonlyrest-docs/blob/master/elasticsearch.md

include:
  - elasticsearch

{% set readonlyrest_version = '1.27.1_es7.11.1' %}

readonlyrest-download:
  file.managed:
    - name: /opt/readonlyrest-{{ readonlyrest_version }}.zip
    - source: https://{{ pillar.github.access_token }}:x-oauth-basic@raw.githubusercontent.com/open-contracting/deploy-salt-private/main/files/readonlyrest-{{ readonlyrest_version }}.zip
    - source_hash: 1f46cfa9849b4b31eac5904bf4304502c5815c03

readonlyrest-install:
  cmd.run:
    - name: "yes | /usr/share/elasticsearch/bin/elasticsearch-plugin install --silent file:///opt/readonlyrest-{{ readonlyrest_version }}.zip"
    - require:
      - pkg: elasticsearch
    - onchanges:
      - file: readonlyrest-download
    - watch_in:
      - service: elasticsearch

/opt/pkcs-password:
  file.managed:
    - name: /opt/pkcs-password
    - contents_pillar: elasticsearch:plugins:readonlyrest:key_pass
    - mode: 600

/opt/pem-to-keystore.sh:
  pkg.installed:
    - name: openjdk-11-jre-headless # for keytool command
  file.managed:
    - name: /opt/pem-to-keystore.sh
    - source: salt://elasticsearch/files/pem-to-keystore.sh
    - mode: 700
    - require:
      - pkg: apache2
      - pkg: elasticsearch
      - pkg: /opt/pem-to-keystore.sh
      - file: /opt/pkcs-password

force load from file:
  file.append:
    - name: /etc/elasticsearch/elasticsearch.yml
    - text:
      # https://github.com/beshu-tech/readonlyrest-docs/blob/master/kibana.md#malformed-in-index-settings
      - "readonlyrest.force_load_from_file: true"

/etc/elasticsearch/readonlyrest.yml:
  file.managed:
    - name: /etc/elasticsearch/readonlyrest.yml
    - source: salt://elasticsearch/files/config/readonlyrest-{{ pillar.elasticsearch.plugins.readonlyrest.configuration }}.yml
    - template: jinja
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch

/etc/elasticsearch/elasticsearch.yml-readonlyrest:
  file.append:
    - name: /etc/elasticsearch/elasticsearch.yml
    - text:
      # https://github.com/beshu-tech/readonlyrest-docs/blob/master/elasticsearch.md#4-disable-x-pack-security-module
      - "xpack.security.enabled: false"
      # https://github.com/beshu-tech/readonlyrest-docs/blob/master/elasticsearch.md#external-rest-api
      - "http.type: ssl_netty4"
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch
