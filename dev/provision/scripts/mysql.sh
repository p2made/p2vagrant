#!/bin/bash

DBHOST=localhost
RTPASSWD=password
DBNAME=mydb
DBUSER=myuser
DBPASSWD=password

# Install MySQL
apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $RTPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $RTPASSWD"

apt-get -y install mysql-server

# Create the database and grant privileges
CMD="mysql -uroot -p$DBPASSWD -e"

$CMD "CREATE DATABASE IF NOT EXISTS $DBNAME"
$CMD "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'%' IDENTIFIED BY '$DBPASSWD';"
$CMD "FLUSH PRIVILEGES;"

# Allow remote access to the database
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart

