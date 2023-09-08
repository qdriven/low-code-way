# QuestDB

A Timeseries Database

Run in Docker:

```sh
docker run -p 9000:9000 \
 -p 9009:9009 \
 -p 8812:8812 \
 -p 9003:9003 \
 -v "$(pwd):/root/.questdb/" questdb/questdb
```

Different Ports:

```
-p 9000:9000 - REST API and Web Console
-p 9009:9009 - InfluxDB line protocol
-p 8812:8812 - Postgres wire protocol
-p 9003:9003 - Min health server
```