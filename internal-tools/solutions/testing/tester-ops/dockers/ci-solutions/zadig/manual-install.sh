export NAMESPACE='zadig'
export DOMAIN=<>
export IP=<IP>
export PORT=<PORT>


NAMESPACE='zadig'
IP="172.21.0.108"

helm upgrade --install zadig --namespace ${NAMESPACE} koderover-chart/zadig --set endpoint.type=IP \
    --set endpoint.IP=${IP} \
    --set ingress-nginx.controller.service.nodePorts.http=${PORT} \
    --set global.extensions.extAuth.extauthzServerRef.namespace=${NAMESPACE} \
    --set "dex.config.staticClients[0].redirectURIs[0]=http://${IP}:${PORT}/api/v1/callback,dex.config.staticClients[0].id=zadig,dex.config.staticClients[0].name=zadig,dex.config.staticClients[0].secret=ZXhhbXBsZS1hcHAtc2VjcmV0"
