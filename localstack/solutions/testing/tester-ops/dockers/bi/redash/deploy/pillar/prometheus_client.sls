firewall:
  prometheus_ipv4: 213.138.113.219
  prometheus_ipv6: 2001:41c8:51:7db::219

prometheus:
  node_exporter:
    service: prometheus-node-exporter
    user: prometheus-client
    basename: node_exporter
    version: 1.0.1
    config:
      # https://github.com/prometheus/node_exporter/blob/v1.0.1/https/README.md
      config.yaml: salt://prometheus/files/config.yaml
      node_exporter.pem: prometheus:node_exporter:ssl:pubcert
