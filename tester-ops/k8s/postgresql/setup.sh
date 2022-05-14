export POSTGRES_PASSWORD=$(kubectl get secret --namespace default postgresql-test -o jsonpath= "{.data.postgresql-password}" | base64 --decode)

kubectl run postgresql-test-client --rm --tty -i --restart= "Never" --namespace 默认 --image docker.io/bitnami/postgresql:11.11.0-debian-10-r31 --env= "PGPASSWORD= $POSTGRES_PASSWORD " --命令-- psql --host postgresql-test -U postgres -d postgres -p 5432


kubectl port-forward --namespace default svc/postgresql-dev 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432

# password
Qz0gVQiFbl