FROM docker.io/centos

ENV PATH ${PATH}:/opt/sbin:/opt/bin

RUN mkdir -p /opt/{sbin,bin}

ENV LOCALE en_US
ENV CHARMAP UTF-8
ENV LANG ${LOCALE}.${CHARMAP}
ENV LC_ALL ${LOCALE}.${CHARMAP}

RUN localedef -i ${LOCALE} -f ${CHARMAP} ${LOCALE}.${CHARMAP}

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV volumeLogs /volumeLogs
ENV volumeDump /volumeDump
ENV volumePersistence /volumePersistence

ENV taobaoRegistry https://registry.npm.taobao.org
ENV nexus=
ENV NodeHome /opt/node
ENV npm_config_nodedir=${NodeHome}
ENV NodeCache ${volumePersistence}/node
ENV NodeVersion v9.4.0-linux-x64
ENV PATH ${NodeHome}/bin:${PATH}

RUN echo -e "prefix = \${NodeHome}\nregistry = \"\${nexus}\"\nstrict-ssl = false\nunsafe-perm = true\ncache = \${NodeCache}\ncache-lock-wait = 300000\ncache-max = 3600" > /root/.npmrc \
    && echo -e "by = npm" >> /root/.cnpmrc

RUN curl -sL https://npm.taobao.org/mirrors/node/${NodeVersion%%-*}/node-${NodeVersion}.tar.gz -o node-${NodeVersion}.tar.gz \
    && mkdir -p ${NodeHome} \
    && cd ${NodeHome} && tar --strip-components 1 -xzf /node-${NodeVersion}.tar.gz \
    && rm -f /node-${NodeVersion}.tar.gz \
    && npm install -g cnpm --registry=${taobaoRegistry}

RUN npm i npm@latest -g

WORKDIR ${NodeHome}/codes
