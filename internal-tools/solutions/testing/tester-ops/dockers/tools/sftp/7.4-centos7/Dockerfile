FROM base/centos:7

ENV SFTP_HOME=/opt/sftp

RUN yum install openssh-server -y && \
    ssh-keygen -A && \
    groupadd sftp && \
    mkdir -p ${SFTP_HOME} && ln -sf ${VOLUME_DATA} ${SFTP_HOME}/data && \
    yum clean all && rm -rf /var/cache/yum

COPY docker-cmd.sh /cmd.sh

WORKDIR ${SFTP_HOME}
EXPOSE 22

CMD /cmd.sh
