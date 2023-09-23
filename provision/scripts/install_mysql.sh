#!/bin/sh

# 07 Install MySQL

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Installing MySQL                                #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get -qy install mysql-server

# Create the database and grant privileges
echo "CREATE USER '$2'@'%' IDENTIFIED BY '$3'" | mysql
echo "CREATE DATABASE IF NOT EXISTS $4" | mysql
echo "CREATE DATABASE IF NOT EXISTS $5" | mysql
echo "GRANT ALL PRIVILEGES ON $4.* TO '$2'@'%';" | mysql
echo "GRANT ALL PRIVILEGES ON $5.* TO '$2'@'%';" | mysql
echo "flush privileges" | mysql

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

cp /var/www/provision/html/db.php /var/www/html/

sudo chmod -R 755 /var/www/html/*

dpkg -l | grep "apache2\|mysql-server-8.1\|php8.2"
