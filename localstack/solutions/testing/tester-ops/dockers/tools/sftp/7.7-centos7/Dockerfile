FROM base/centos:7

ENV OPENSSH_HOME=/opt/openssh
ENV SFTP_HOME=/opt/sftp \
    PATH=${OPENSSH_HOME}/bin:${OPENSSH_HOME}/sbin:${PATH}

RUN groupadd -g 74 sshd && groupadd sftp && \
    useradd -u 74 -g sshd -d /var/empty/sshd -s /sbin/nologin -c 'Privilege-separated SSH' sshd && \
    yum install gcc make -y && yum-builddep openssh -y && \
    curl ${RESOURCES_SERVER}/openssh/openssh-7.7p1.tar.gz | tar xz -C /tmp && cd /tmp/openssh-7.7p1 && \
    ./configure --prefix=${OPENSSH_HOME} && make && make install && \
    mkdir -p ${SFTP_HOME} && ln -sf ${VOLUME_DATA} ${SFTP_HOME}/data && \
    echo 'umask 0002' >> /etc/bashrc && \
    yum remove gcc make -y && yum clean all && rm -rf /var/cache/yum /tmp/openssh-7.7p1 

COPY docker-cmd.sh /cmd.sh

WORKDIR ${SFTP_HOME}
EXPOSE 22

CMD /cmd.sh
