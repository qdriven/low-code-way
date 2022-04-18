#!/bin/sh

mkdir -p metadata-demos
cd metadata-demos
python3 -m venv env
source env/bin/activate
pip3 install --upgrade pip setuptools
pip3 install --upgrade 'openmetadata-ingestion[docker]'
metadata docker -help