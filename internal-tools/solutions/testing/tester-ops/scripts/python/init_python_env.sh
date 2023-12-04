#! /bin/sh

PY_VERSION=$1

if [ "${PY_VERSION}" = "" ];then
    PY_VERSION="3.8"
fi

conda create -n $2 python=${PY_VERSION}