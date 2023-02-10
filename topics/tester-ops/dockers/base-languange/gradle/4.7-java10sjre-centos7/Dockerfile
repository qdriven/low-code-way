FROM base/java:10sjre-centos7

ENV GRADLE_HOME /opt/gradle
ENV PATH ${GRADLE_HOME}/bin:${PATH}

RUN curl -o /tmp/gradle-4.7-bin.zip ${RESOURCES_SERVER}/gradle/gradle-4.7-bin.zip && \
    unzip /tmp/gradle-4.7-bin.zip && mv gradle-4.7 ${GRADLE_HOME} && \
    chown ${DEFAULT_USER}:${DEFAULT_USER} ${GRADLE_HOME} -R && \
    rm -rf /tmp/gradle-4.7-bin.zip

WORKDIR /mnt
