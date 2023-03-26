#! /bin/sh
dir=$(cd $(dirname $0); pwd)
FILE_NAME=$1
echo "start import ${FILE_NAME}"

mysql -uroot -p123456 <$dir/${FILE_NAME}

echo "IMPORT FILE Successfully!"

# create database scheme
mysql create database <>