brew install redis mariadb@10.3 python@3.10 
brew install --cask wkhtmltopdf


nano /usr/local/etc/my.cnf
# nano /opt/homebrew/etc/my.cnf
brew services restart mariadb

# [mysqld]
# character-set-client-handshake = FALSE
# character-set-server = utf8mb4
# collation-server = utf8mb4_unicode_ci
# bind-address = 127.0.0.1

# [mysql]
# default-character-set = utf8mb4

pip3 install frappe-bench
bench init frappe-bench
bench start


