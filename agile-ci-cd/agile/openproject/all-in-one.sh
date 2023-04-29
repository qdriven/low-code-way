# docker run -it -p 8080:80 \
#   -e OPENPROJECT_SECRET_KEY_BASE=secret \
#   -e OPENPROJECT_HOST__NAME=localhost:8080 \
#   -e OPENPROJECT_HTTPS=false \
#   openproject/community:12
sudo mkdir -p /var/lib/openproject/{pgdata,assets} 
docker run -d -p 8080:80 --name openproject \
  -e OPENPROJECT_HOST__NAME=openproject.example.com \
  -e OPENPROJECT_SECRET_KEY_BASE=secret \
  -v /var/lib/openproject/pgdata:/var/openproject/pgdata \
  -v /var/lib/openproject/assets:/var/openproject/assets \
  openproject/community:12