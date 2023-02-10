# K8S Basic Usage

## 获取POD

```sh
kubectl get all
```

## 删除POD

```sh
kubectl del all
```

## Helm 命令

```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm repo update
helm install postgresql-dev bitnami/postgresql
helm list

kubectl delete pvc -l release=my-release
```