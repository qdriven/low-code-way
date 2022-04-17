# ToolJet Setup

```shell
#!/bin/sh
mkdir -p tooljet/fallbackcerts tooljet/logs tooljet/certs
docker-compose up -d 
docker-compose run server npm run db:seed
```

## Default login User

user: ```dev@tooljet.io/password```
