#!/bin/bash

kubectl delete all --all -n selenosis

kubectl apply -f 01-namespace.yaml
kubectl delete configmap selenosis-config -n selenosis
kubectl create cm selenosis-config --from-file=browsers.yaml=browsers.yaml -n selenosis
kubectl apply -f 02-service.yaml
kubectl get svc -n selenosis
kubectl apply -f 03-selenosis.yaml
kubectl apply -f 04-selenoid-ui.yaml
kubectl apply -f 05-selenosis-hpa.yaml
kubectl apply -f 06-resource-quota.yaml -n selenosis
kubectl get po -n selenosis
kubectl get svc -n selenosis