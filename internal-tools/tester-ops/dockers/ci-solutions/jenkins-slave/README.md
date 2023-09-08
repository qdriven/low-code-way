# Build CI/CD Jenkins Pipeline

There are several steps to build a Jenkins Pipeline:
- Build Jenkins or Jenkins BlueOcean
- Setup A Hello World Application
- Setup Github Repo in Jenkins and Jenkins Pipeline file
- Push Commit to trigger Jenkins

## Setup Jenkins Server

It is easy to setup Jenkins/BlueOcean Server via docker. Just follow these steps:

- Setup Docker
- Checkout docker-compose is installed
```sh
docker-compose -h
```
- Create docker-compose files

```yml
version: "3.3"
services:
  jenkins:
    image: jenkinsci/blueocean:latest
    container_name: tops_jenkins
    user: root
    restart: always
    ports:
      - "9090:8080"
      - "50000:5000"
    volumes:
      - "./data:/var/jenkins_home"
      # - "/var/run/docker.sock:/var/run/docker.sock"
```
- Running the docker-compose command to start Jenkins server

```sh
docker-compose up -f docker-compose.yml
```

- checkout the jenkins server

visit: localhost:9090, it is OK/

## Setup A Simple Hello World SpringBoot Application

It is easy to setup a SpringBoot Hello World Applicaiton. 
Please Refer:

## The pipeline stages:

- Dev
- QA
- PROD

In every Stage:

- CHECKOUT
- BUILD
- TEST
- DEPLOY