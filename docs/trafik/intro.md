# Trafik Proxy

Edge Router:

![img](https://doc.traefik.io/traefik/assets/img/traefik-concepts-1.png)

![](https://doc.traefik.io/traefik/assets/img/traefik-concepts-2.png)

## Quick Start

Using Docker: 
![](https://doc.traefik.io/traefik/assets/img/quickstart-diagram.png)


## Run trafik docker

```sh
docker-compose up -d reverse-proxy
```

## Detect New Service

```sh
docker-compose up -d whoami

```
http://localhost:8080/api/rawdata

```sh
docker-compose up -d --scale whoami=2
```

```sh
curl -H Host:whoami.docker.localhost http://127.0.0.1
```


## Docs

- [traefik-docs](https://doc.traefik.io/)
