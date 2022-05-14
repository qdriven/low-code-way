#!/usr/bin/env bash

CONTAINER_NAME=$1
c_id=$(docker ps -a | grep "${CONTAINER_NAME}")
echo "${c_id}"
sudo docker stop "${c_id}"
sudo docker rm "${c_id}"
