FROM centos:7.4.1708

ENV LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    DEFAULT_USER=tux \
    VOLUME_LOGS=/volume_logs VOLUME_DATA=/volume_data \
    HOME=/root 
    # RESOURCES_SERVER= 

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    groupadd -g 1996 ${DEFAULT_USER} && useradd -u 1996 -g 1996 ${DEFAULT_USER} && \
    mkdir -p ${VOLUME_LOGS} ${VOLUME_DATA} && \
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup && \
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
    yum install which traceroute bind-utils net-tools telnet unzip bash-completion yum-utils -y && \
    yum clean all && rm -rf /var/cache/yum
