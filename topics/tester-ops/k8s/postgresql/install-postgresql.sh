#!/bin/sh

helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm repo update
helm install postgresql-dev bitnami/postgresql