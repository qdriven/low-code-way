python_apps:
  cove: # adds to cove.sls
    git:
      url: https://github.com/open-contracting/cove-oc4ids.git
    django:
      env:
        ALLOWED_HOSTS: .standard.open-contracting.org,.oc4ids.opencontracting.uk0.bigv.io
        FATHOM_ANALYTICS_ID: UHUGOEOK
    apache:
      servername: cove-live.oc4ids.opencontracting.uk0.bigv.io
      context:
        assets_base_url: /infrastructure
