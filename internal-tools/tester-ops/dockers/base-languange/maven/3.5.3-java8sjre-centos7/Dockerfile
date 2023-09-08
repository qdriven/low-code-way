FROM base/java:8sjre-centos7

ENV M2_HOME /opt/maven
ENV PATH ${M2_HOME}/bin:${PATH}

RUN curl ${RESOURCES_SERVER}/maven/apache-maven-3.5.3-bin.tar.gz | tar xz -C /opt && \
    mv /opt/apache-maven-3.5.3 ${M2_HOME} && \
    mkdir -p  /root/.m2 && \
    chown ${DEFAULT_USER}:${DEFAULT_USER} ${M2_HOME} -R

COPY settings.xml /root/.m2/settings.xml

WORKDIR /mnt
