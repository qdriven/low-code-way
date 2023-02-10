FROM base/centos:7

ENV JAVA_HOME=/opt/java
ENV PATH=${JAVA_HOME}/bin:${PATH}

WORKDIR /opt/app

RUN curl ${RESOURCES_SERVER}/sjre/serverjre-10.0.1_linux-x64_bin.tar.gz | tar xz -C /opt && \
    mv /opt/jdk-10.0.1 ${JAVA_HOME} && \
    chown ${DEFAULT_USER}:${DEFAULT_USER} ${JAVA_HOME} -R

RUN sed -i 's/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=60/' ${JAVA_HOME}/conf/security/java.security
ADD run-java.sh /opt/app
RUN chmod +x /opt/app/run-java.sh

ENTRYPOINT /opt/app/run-java.sh
