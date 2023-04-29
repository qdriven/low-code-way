git clone https://github.com/opf/openproject-deploy --depth=1 --branch=stable/12 openproject
cd openproject/compose
docker-compose up -d


# docker run -it -p 8080:80 \
#   -e OPENPROJECT_SECRET_KEY_BASE=secret \
#   -e OPENPROJECT_HOST__NAME=localhost:8080 \
#   -e OPENPROJECT_HTTPS=false \
#   openproject/community:12