include:
  - docker

# =================================================================================================
# See https://ocdsdeploy.readthedocs.io/en/latest/deploy/redash.html for installation instructions.
# =================================================================================================

redash_prepackages:
  pkg.installed:
    - pkgs:
      - pwgen
      - postgresql-client-10

/opt/redash:
  file.directory:
    - makedirs: True
