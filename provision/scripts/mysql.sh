#!/bin/bash

# 05 Install MySQL 8.1

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                 #####"
echo "#####            ¡¡¡ Installing MySQL !!!             #####"
echo "#####                                                 #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"

#MYSQL_VERSION   = $1
#RT_PASSWORD     = $2
#DB_USERNAME     = $3
#DB_PASSWORD     = $4
#DB_NAME         = $5
#DB_NAME_TEST    = $6

# Install MySQL
apt-get update
apt-get -y install mysql-server

debconf-set-selections <<< "mysql-server mysql-server/root_password password Pa$$w0rd0ne"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password Pa$$w0rd0ne"

# Create the database and grant privileges
mysql -uroot -p$2 -e "CREATE DATABASE IF NOT EXISTS $5;"
mysql -uroot -p$2 -e "CREATE DATABASE IF NOT EXISTS $6;"
mysql -uroot -p$2 -e "CREATE USER '$3@%' IDENTIFIED BY '$4';"
mysql -uroot -p$2 -e "GRANT ALL PRIVILEGES ON *.* TO '$3@%';"
mysql -uroot -p$2 -e "FLUSH PRIVILEGES;"

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
#grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart
