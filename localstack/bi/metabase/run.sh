
docker run -d -p 3000:3000 --name metabase metabase/metabase \
    -v ~/metabase-data:/metabase-data

# docker run -d -p 3000:3000 \
#   -e "MB_DB_TYPE=postgres" \
#   -e "MB_DB_DBNAME=metabaseappdb" \
#   -e "MB_DB_PORT=5432" \
#   -e "MB_DB_USER=name" \
#   -e "MB_DB_PASS=password" \
#   -e "MB_DB_HOST=my-database-host" \
#    --name metabase metabase/metabase

# docker run -d -p 3000:3000 \
#   -v ~/metabase-data:/metabase-data \
#   -e "MB_DB_FILE=/metabase-data/metabase.db" \
#   --name metabase metabase/metabase

