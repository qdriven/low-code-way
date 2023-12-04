#!/bin/bash

set -e

if [ "${1}" == "jpda" ]; then
    JAVA_OPTS="${JAVA_OPTS} -agentlib:jdwp=transport=dt_socket,address=${JPDA_ADDRESS},server=y,suspend=n"
    shift
fi

[ -n "${JMX_IP}" ] && [ -n "${JMX_PORT}" ] && JAVA_OPTS="${JAVA_OPTS} -Djava.rmi.server.hostname=${JMX_IP} -Dcom.sun.management.jmxremote.port=${JMX_PORT} -Dcom.sun.management.jmxremote.rmi.port=${JMX_PORT} -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

if [ "${1#-}" != "${1}" ] || [ "${1##*.}" ==  "jar" ] || [ "${1##*.}" ==  "war" ]; then
    set -- java -jar ${JAVA_OPTS} ${@} ${SPRINGBOOT_OPTS}
fi

exec "${@}"
