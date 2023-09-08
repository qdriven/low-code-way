FROM base/java:10sjre-centos7 

ENV SPRINGBOOT_HOME /opt/springboot
ENV JPDA_ADDRESS 8000

RUN mkdir -p ${SPRINGBOOT_HOME} && chown ${DEFAULT_USER}:${DEFAULT_USER} ${SPRINGBOOT_HOME} && \
    ln -sf ${VOLUME_LOGS} ${SPRINGBOOT_HOME}/logs && \
    ln -sf ${VOLUME_DATA} ${SPRINGBOOT_HOME}/data

WORKDIR ${SPRINGBOOT_HOME}
EXPOSE 8080 ${JPDA_ADDRESS}

COPY docker-entrypoint.sh /entrypoint.sh
CMD ["ROOT.jar"]
ENTRYPOINT ["/entrypoint.sh"]
