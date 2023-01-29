#!/bin/sh
brew install redis mariadb@10.3
brew install --cask wkhtmltopdf
pip3 install frappe-bench


## nvm
## brew service restart mariabd
# brew install postgresql


## my.cnf
# [mysqld]
# character-set-client-handshake = FALSE
# character-set-server = utf8mb4
# collation-server = utf8mb4_unicode_ci

# [mysql]
# default-character-set = utf8mb4


# npm install -g yarn
