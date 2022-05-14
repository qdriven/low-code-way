FROM nginx:1.14-alpine
LABEL maintainer="patrick"

ENV ROOT_DIR=/opt/app

WORKDIR ${ROOT_DIR}

EXPOSE 8080

RUN mkdir -p ${ROOT_DIR} && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    echo "<code>Add your index.html to ${ROOT_DIR}: COPY index.html ${ROOT_DIR}/index.html</code>" > ${ROOT_DIR}/index.html

COPY default.conf /etc/nginx/conf.d/default.conf    

CMD ["nginx"]
