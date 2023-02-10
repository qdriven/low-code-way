#!/bin/sh 

export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=postgresql,role=master -o jsonpath="{.items[0].metadata.name}")

kubectl delete statefulsets.apps postgresql-postgresql --cascade=false