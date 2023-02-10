# Defines which pillars should be used for each target.

base:
  '*':
    - common
    - private.common

  'cove-oc4ids':
    - cove
    - cove_oc4ids
    - private.cove_oc4ids
    - maintenance

  'cove-ocds':
    - cove
    - cove_ocds
    - private.cove_ocds
    - maintenance

  'covid19*':
    - covid19
    - private.covid19

  'covid19':
    - covid19_maintenance

  'covid19-dev':
    - covid19_dev

  'docs':
    - docs
    - private.docs
    - tinyproxy
    - docs_maintenance

  'kingfisher-process':
    - kingfisher
    - private.kingfisher
    - tinyproxy
    - kingfisher_process_maintenance

  'kingfisher-replica':
    - kingfisher_replica
    - private.kingfisher_replica
    - kingfisher_replica_maintenance

  'prometheus':
    - prometheus_server
    - private.prometheus_server
    - maintenance

  'redash':
    - redash
    - maintenance

  'spoonbill-dev':
    - spoonbill_dev

  'toucan':
    - toucan
    - private.toucan
    - maintenance

  # Don't install the Prometheus Node Exporter on development or test servers.
  '* and not G@id:*-dev and not G@id:*-test':
    - prometheus_client
    - private.prometheus_client
