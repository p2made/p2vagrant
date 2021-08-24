#!/bin/bash

# MYSQL_VERSION    $1
# RT_PASSWORD      $2
# DB_USERNAME      $3
# DB_PASSWORD      $4
# DB_NAME          $5
# DB_NAME_TEST     $6

# Install MySQL
apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $2"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $2"

apt-get -y install mysql-server-$1

# Create the database and grant privileges
CMD="sudo mysql -uroot -p$2 -e"

$CMD "CREATE DATABASE IF NOT EXISTS $5"
$CMD "GRANT ALL PRIVILEGES ON $5.* TO '$3'@'%' IDENTIFIED BY '$4';"
$CMD "CREATE DATABASE IF NOT EXISTS $6"
$CMD "GRANT ALL PRIVILEGES ON $6.* TO '$3'@'%' IDENTIFIED BY '$4';"
$CMD "FLUSH PRIVILEGES;"

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart
