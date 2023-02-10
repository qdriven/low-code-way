#!/bin/sh

poetry new metadata-app 

cd metadata-app
poetry shell
touch .gitignore
echo ".venv/" >> .gitignore
echo ".pyc" >>.gitignore
poetry add 'openmetadata-ingestion[docker]'
metadata docker -help
