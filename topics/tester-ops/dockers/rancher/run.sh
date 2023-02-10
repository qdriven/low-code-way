#! /bin/sh 

sudo docker run -d --restart=unless-stopped -v \
    rancher:/var/lib/rancher/ \
    -p 80:80 -p 443:443 rancher/rancher:stable
