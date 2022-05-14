# Postgresql

Why Postgresql? postgresql在功能上面比mysql要来的丰富，因此在大部分场景下面postgresql都可以完成工作.

## 使用Docker-Compose文件构建

```yaml
version: '3.8'

services:
  postgres:
    container_name: pg_db
    image: postgres:latest
    env_file:
      - .env
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-postgres}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-changeit}
    volumes:
       - ~/data/postgres:/var/lib/postgresql/data
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    restart: unless-stopped
```

## Run Postgresql

```sh
docker-compose up -d
```

## Docker 命令check log

```sh
docker ps -aq| xargs docker logs
```