#! /bin/sh
mkdir -p roles/$1/handlers
mkdir -p roles/$1/tasks
touch  roles/$1/tasks/main.yml
touch  roles/$1/handlers/main.yml
mkdir -p roles/$1/vars
mkdir -p roles/$1/files
mkdir -p roles/$1/templates
mkdir -p roles/$1/meta
mkdir -p roles/$1/meta/main.yml
mkdir -p roles/$1/defaults
touch roles/$1/defaults/main.yml