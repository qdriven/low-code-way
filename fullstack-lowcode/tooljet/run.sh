#!/bin/sh
mkdir -p tooljet/fallbackcerts tooljet/logs tooljet/certs postgres_data
docker-compose up -d 
docker-compose run server npm run db:seed


# email: dev@tooljet.io
# password: password