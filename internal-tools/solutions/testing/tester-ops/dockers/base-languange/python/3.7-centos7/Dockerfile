FROM base/centos:7

ENV PYTHON_HOME=/opt/python
ENV PATH=${PYTHON_HOME}/bin:${PATH}
ENV PAYTHON_VERSION=3.7

RUN yum install gcc make readline-devel openssl-devel zlib-devel bzip2-devel xz-devel ncurses-devel sqlite-devel gdbm-devel tk-devel -y && \
    curl ${RESOURCES_SERVER}/python/Python-${PAYTHON_VERSION}}.tgz | tar xz -C /tmp && cd /tmp/Python-${PAYTHON_VERSION}} && \
    ./configure --prefix=${PYTHON_HOME} --enable-optimizations && make && make install && \
    mkdir -p ${HOME}/.pip && \
    chown ${DEFAULT_USER}:${DEFAULT_USER} ${PYTHON_HOME} -R && \
    rm -rf /tmp/Python-${PAYTHON_VERSION}}

COPY pip.conf /root/.pip/
