docker run --init \
  --name bytebase \
  --restart always \
  --add-host host.docker.internal:host-gateway \
  --publish 80:80 \
  --health-cmd "curl --fail http://localhost:80/healthz || exit 1" \
  --health-interval 5m \
  --health-timeout 60s \
  --volume ~/data/bytebase/data:/var/opt/bytebase \
  bytebase/bytebase:1.3.1 \
  --data /var/opt/bytebase \
  --host https://bytebase.example.com \
  --port 80
