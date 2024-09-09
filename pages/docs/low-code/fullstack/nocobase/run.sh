# for SQLite
# docker run -d --name nocodb \
# -v "$(pwd)"/nocodb:/usr/app/data/ \
# -p 8080:8080 \
# nocodb/nocodb:latest

# # for MySQL
# docker run -d --name nocodb-mysql \
# -v "$(pwd)"/nocodb:/usr/app/data/ \
# -p 8080:8080 \
# -e NC_DB="mysql2://host.docker.internal:3306?u=root&p=password&d=d1" \
# -e NC_AUTH_JWT_SECRET="569a1821-0a93-45e8-87ab-eb857f20a010" \
# nocodb/nocodb:latest

# for PostgreSQL
# -v "$(pwd)"/nocodb:/usr/app/data/ \

docker run -d --name nocodb-pg \
-p 8080:8080 \
-e NC_DB="pg://db.supabase.orb.local:7432?u=postgre&p=changeit&d=nocodb" \
-e NC_AUTH_JWT_SECRET="569a1821-0a93-45e8-87ab-eb857f20a010" \
nocodb/nocodb:latest

# for MSSQL
# docker run -d --name nocodb-mssql \
# -v "$(pwd)"/nocodb:/usr/app/data/ \
# -p 8080:8080 \
# -e NC_DB="mssql://host.docker.internal:1433?u=root&p=password&d=d1" \
# -e NC_AUTH_JWT_SECRET="569a1821-0a93-45e8-87ab-eb857f20a010" \
# nocodb/nocodb:latest