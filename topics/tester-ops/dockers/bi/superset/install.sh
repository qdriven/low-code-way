#!/bin/sh

cd ../playground
git clone https://github.com/apache/superset.git --depth=1
docker-compose -f docker-compose-non-dev.yml up
