#/bin/sh

CWD=`pwd`
for folder in ./*
do
    if test -d $folder
    then
        cd ${folder}
        git pull
        cd ..
    fi
done 