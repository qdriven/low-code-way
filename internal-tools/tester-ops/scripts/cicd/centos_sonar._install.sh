#! /bin/sh

sudo rpm -Uvh https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
sudo yum -y install postgresql96-server postgresql96-contrib
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl start postgresql-9.6
sudo systemctl enable postgresql-9.6
sudo su postgres
psql
createuser sonar
ALTER USER sonar WITH ENCRYPTED password 'sonar';
CREATE DATABASE sonar WITH ENCODING 'UTF8' OWNER sonar TEMPLATE=template0;
CREATE DATABASE sonar OWNER sonar;
psql -h localhost -d sonar -U sonar -W

echo "
sonar.jdbc.username=sonar \
sonar.jdbc.password=sonar \
sonar.jdbc.url=jdbc:postgresql://localhost/sonar
" >> sonar.conf