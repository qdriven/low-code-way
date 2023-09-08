ssh:
  docs:
    # Public key for salt/private/keys/docs_ci
    - no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYvnxKiBcHVLpAJl+eO4zghzvQlo3GmzLvpNItSz6fjsvWAxQRH7aAZSD4cbX+m13qT60qiw63o5rc2t0CF02CGa+Dru0+lTHjVZTxsmyg7PhIPlHmz55QPP2S69uD++VEjgLSWC1MwUlq1I/mU8hAvMNb5ESs7vciOgmRbcWOdFCdKYKj4Az6I8p1MUExUw/8NDRP2HUrN5SbeFJ+u9eJfJBYAJYSspFB3SOesSmx2RP+vB9AP+3YEaBLGYNe3Ev5sOyWbPvEpcqtrD1Zf1MVKJCOlnz9I1I+o3aZmJu1TRu3V16XVctBV0d+rUrkgVcx/KIfeeL6NGACaUrl1SlRAUMzPwv6jcwwcHLadBhk154RThR3IIAG44wRT8/FaHUkDgiSKhqGmsc1nVu+vNSZ+1nun5xFEu0357oc/zywylFKX7lzeT40nM3dd43mmhtZAE3NjLduBiJC3gB5TQkr+l+K1GjiGeUD1uXFhvkbm9DtdTrFHwciq2rkCM3pmsMrO6fgMkj/pQM5WEFpJH67aohHNqohUKDDiU/EHTGliT7LxHOtmvPX5AFXDviZIrTnlmAn2J3IXeos84m6A1I8raRh4yQC+Gfosp1EHvuE/6V9Th9IeSKLmqVLUgLdUs3IoWAMqw+Nj3f/Krr+jd9bGDDNSaquNwiFF2ccgTspqQ==

shared-context: &shared-context
  ocds_cove_backend: https://cove.live3.cove.opencontracting.uk0.bigv.io
  oc4ids_cove_backend: https://cove-live.oc4ids.opencontracting.uk0.bigv.io
  timeout: 1830  # 30 sec longer than cove's uwsgi.harakiri

apache:
  public_access: True
  modules:
    mod_md:
      MDNotifyCmd: /opt/pem-to-keystore.sh
  sites:
    ocds-docs-live:
      configuration: docs
      servername: standard.open-contracting.org
      context:
        testing: False
        <<: *shared-context
    # For information on the testing virtual host, see:
    # https://ocdsdeploy.readthedocs.io/en/latest/develop/update.html#using-a-testing-virtual-host
    ocds-docs-live-testing:
      configuration: docs
      servername: testing.live.standard.open-contracting.org
      context:
        testing: True
        <<: *shared-context
    ocds-legacy:
      configuration: docs-legacy
      servername: ocds.open-contracting.org

elasticsearch:
  public_access: True
  # Allow OCDS documentation and GitHub Actions.
  allowed_origins: "*"
  plugins:
    readonlyrest:
      configuration: docs

vm:
  swappiness: 1
