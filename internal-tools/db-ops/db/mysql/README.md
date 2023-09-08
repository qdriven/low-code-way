# MYSQL Intro

```sh 
docker run --name=mysql_db1 -d mysql:latest
```

![img](img/failed_run_docker_mysql.png)

```sh 
docker run --name=mysql_db1 -d mysql:latest --env="MYSQL_ROOT_PASSWORD=123456"
```

docker run -d -p 3306:3306 --name=mysql_db1 -e MYSQL_ROOT_PASSWORD=123456 mysql 
