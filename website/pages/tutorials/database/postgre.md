# Postgresql For QA


## Setup Local 

Use docker and orbstack in Mac to manager local database.
1. Tools: 
    - docker
    - docker-compose
    - orbstack which is very ligth weight compared with Docker desktop
2. Docker-Compose file

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

3. Command to Run

```sh
docker-compose up -d
```

Done.


