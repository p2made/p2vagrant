#!/bin/bash

# 04 Install MySQL 8.1

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### #####"
echo "##### #####       Installing MySQL"
echo "##### #####"
echo "##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### #####"\n

# RT_PASSWORD         = "Passw0rd0ne"         | $1
# DB_USERNAME         = "fredspotty"          | $2
# DB_PASSWORD         = "Passw0rdTw0"         | $3
# DB_NAME             = "example_db"          | $4
# DB_NAME_TEST        = "example_db_test"     | $5

apt-get update

apt-get -y install mysql-server libapache2-mod-auth-mysql

debconf-set-selections <<< "mysql-server mysql-server/root_password password $1"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $1"

# Create the database and grant privileges
sudo mysql -uroot -p$1 -e "CREATE USER '$2'@'%' IDENTIFIED BY '$3';"
sudo mysql -uroot -p$1 -e "CREATE DATABASE IF NOT EXISTS $4"
sudo mysql -uroot -p$1 -e "GRANT ALL PRIVILEGES ON $4.* TO '$2'@'%'"
sudo mysql -uroot -p$1 -e "CREATE DATABASE IF NOT EXISTS $5"
sudo mysql -uroot -p$1 -e "GRANT ALL PRIVILEGES ON $5.* TO '$2'@'%'"

#echo "create database development" | mysql
#echo "CREATE USER 'development'@'localhost' IDENTIFIED BY 'development'" | mysql
#echo "GRANT ALL PRIVILEGES ON development.* TO 'development'@'localhost';" | mysql
#echo "flush privileges" | mysql

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
#grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo ""sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf"

# Verify installations
sudo dpkg -l | grep "apache2\|mysql-server-8.1\|php8.2"
