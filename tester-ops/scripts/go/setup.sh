#! /bin/sh
echo "export GO111MODULE=on" >> ~/.zshrc
echo "export GOPROXY=https://mirrors.aliyun.com/goproxy/" >>~/.zshrc
source ~/.zshrc
go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
