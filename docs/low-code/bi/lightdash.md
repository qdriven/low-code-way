# Lightdash 

## Lightdash self-host

```sh

export LIGHTDASH_SECRET="not very secret" 
export PGPASSWORD="password"

docker-compose -f docker-compose.yml up --env-file .env --detach --remove-orphans
```