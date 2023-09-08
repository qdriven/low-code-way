#! /bin/sh

MODULE_NAME=$1
git submodule add $MODUEL_NAME

git pull --recurse-submodules