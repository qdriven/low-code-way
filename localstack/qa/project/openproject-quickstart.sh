# run openproject
sudo mkdir -p /var/lib/openproject/{pgdata,assets}
secret=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo ''`
echo ${secret}
docker run -d -p 8080:80 -p 5432:5432 --name openproject \
  -e OPENPROJECT_HOST__NAME=openproject.example.com \
  -e OPENPROJECT_SECRET_KEY_BASE=${secret} \
  -v /var/lib/openproject/pgdata:/var/openproject/pgdata \
  -v /var/lib/openproject/assets:/var/openproject/assets \
  openproject/community:13

# generate seed
# login: admin, password: admin