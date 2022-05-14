#! /bin/sh

docker run --name=mysql_db_1 -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=qmeta \
 -e MYSQL_USER=qmeta -e MYSQL_PASSWORD=qa123456  \
  -v /data/mysql:/var/lib/mysql -d mysql \
  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --default-authentication-plugin=mysql_native_password

