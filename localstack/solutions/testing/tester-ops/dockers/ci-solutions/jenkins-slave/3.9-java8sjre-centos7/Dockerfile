FROM base/java:8sjre-centos7

ENV JENKINS_AGENT_WORKDIR=/slave

RUN yum install git -y && yum clean all && rm -rf /var/cache/yum && \
    curl -o /opt/agent.jar ${RESOURCES_SERVER}/jenkins/remoting-3.9.jar

CMD java ${JAVA_OPTS} -jar /opt/agent.jar -jnlpUrl ${JENKINS_URL}/computer/${JENKINS_AGENT_NAME}/slave-agent.jnlp \
    -secret ${JENKINS_SECRET} -workDir ${JENKINS_AGENT_WORKDIR}
