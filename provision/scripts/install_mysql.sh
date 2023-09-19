#!/bin/sh

# 04 Install MySQL 8.1

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "#####"
echo -e "#####       Installing MySQL "$1
echo -e "#####"
echo -e "##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### #####\n\n"

# MYSQL_VERSION       = "8.1"                 | $1
# RT_PASSWORD         = "Passw0rd0ne"         | $2
# DB_USERNAME         = "fredspotty"          | $3
# DB_PASSWORD         = "Passw0rdTw0"         | $4
# DB_NAME             = "example_db"          | $5
# DB_NAME_TEST        = "example_db_test"     | $6

apt-get update

apt-get -qy install mysql-server

debconf-set-selections <<< "mysql-server mysql-server/root_password password $2"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $2"

# Create the database and grant privileges
CMD="sudo mysql -uroot -pPassw0rd0ne -e"

$CMD "CREATE USER '$3'@'%' IDENTIFIED BY '$4';"
$CMD "CREATE DATABASE IF NOT EXISTS $5"
$CMD "GRANT ALL PRIVILEGES ON $5.* TO '$3'@'%'"
$CMD "CREATE DATABASE IF NOT EXISTS $6"
$CMD "GRANT ALL PRIVILEGES ON $6.* TO '$3'@'%'"

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

cp /var/www/provision/html/db.php /var/www/html/db.php

sudo dpkg -l | grep "apache2\|mysql-server-8.1\|php8.2"
