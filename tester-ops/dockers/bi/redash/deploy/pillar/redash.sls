apache:
  public_access: True
  sites:
    redash:
      configuration: proxy
      servername: redash.open-contracting.org
      context:
        proxypass: http://localhost:9090/
