FROM base/centos:7

ENV JAVA_HOME=/opt/java
ENV PATH=${JAVA_HOME}/bin:${PATH}

RUN curl ${RESOURCES_SERVER}/sjre/server-jre-8u172-linux-x64.tar.gz | tar xz -C /opt && \
    mv /opt/jdk1.8.0_172 ${JAVA_HOME} && \
    chown ${DEFAULT_USER}:${DEFAULT_USER} ${JAVA_HOME} -R

WORKDIR /opt/app

RUN sed -i 's/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=60/' ${JAVA_HOME}/jre/lib/security/java.security
ADD run-java.sh /opt/app
RUN chmod +x /opt/app/run-java.sh

ENTRYPOINT /opt/app/run-java.sh
