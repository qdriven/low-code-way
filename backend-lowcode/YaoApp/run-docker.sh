#!/bin/sh

docker run -d --name yao-apps \
    -v ./data:/data/app -p 5099:5099 yaoapp/yao:0.9.1-amd64-dev