#! /bin/sh
KEYWORD=$1
result=`ps -ef | grep "${KEYWORD}" | grep -v grep | awk '{print $2}'`
echo $result

for item in $result;do
    kill -9 item
done