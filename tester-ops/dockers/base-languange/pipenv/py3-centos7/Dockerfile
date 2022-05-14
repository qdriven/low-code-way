FROM base/python:3-centos7
LABEL maintainer="patrick" 
WORKDIR /opt/app
RUN set -ex && yum install -y openldap-devel mariadb-devel && yum clean all
RUN set -ex && mkdir -p /opt/app && pip3 install --upgrade pip pipenv
ONBUILD COPY Pipfile Pipfile
ONBUILD COPY Pipfile.lock Pipfile.lock
ONBUILD RUN set -ex && pipenv install --deploy --system
