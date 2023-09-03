#!/bin/bash

# 05 Install MySQL 8.1

#MYSQL_VERSION   = $1 = 8.1
#RT_PASSWORD     = $2 = "Pa$$w0rd0ne"
#DB_USERNAME     = $3 = "fredspotty"
#DB_PASSWORD     = $4 = "Pa$$w0rdTw0"
#DB_NAME         = $5 = "example_db"
#DB_NAME_TEST    = $6 = "example_db_test"

# Install MySQL
apt-get update
apt-get -y install mysql-server

debconf-set-selections <<< "mysql-server mysql-server/root_password password Pa$$w0rd0ne"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password Pa$$w0rd0ne"

# Create the database and grant privileges
CMD="sudo mysql -uroot -p$2 -e"

$CMD "CREATE USER '$3'@'%' IDENTIFIED BY '$4';"
$CMD "CREATE DATABASE IF NOT EXISTS $5"
$CMD "GRANT ALL PRIVILEGES ON $5.* TO '$3'@'%'"
$CMD "CREATE DATABASE IF NOT EXISTS $6"
$CMD "GRANT ALL PRIVILEGES ON $6.* TO '$3'@'%'"

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
#grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart
