#! /bin/sh

PROJECT_NAME=$1
PACKAGE_NAME=io.qmeat.${PROJECT_NAME}
mkdir -p ${PROJECT_NAME} && cd ${PROJECT_NAME}


curl 'https://start.spring.io/starter.zip?type=maven-project& \
        language=kotlin&bootVersion=2.2.5.RELEASE \
        &baseDir=eng-profiles&groupId=io.qmeta&artifactId=eng-profiles&name=eng-profiles \
        &description=${PROJECT_NAME}&packageName=io.qmeta.${PROJECT_NAME}& \
        packaging=jar&javaVersion=1.8&dependencies=web,data-jpa,devtools,h2,actuator,codecentric-spring-boot-admin-server,codecentric-spring-boot-admin-client' \
        -H 'authority: start.spring.io' \
        -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.100 Safari/537.36' \
        -H 'sec-fetch-dest: empty' -H 'accept: */*' -H 'sec-fetch-site: same-origin' \
        -H 'sec-fetch-mode: cors' -H 'referer: https://start.spring.io/' --compressed
        -H 'accept-language: en-US,en;q=0.9'  -O ${PROJECT_NAME}.zip