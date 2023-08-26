#!/bin/bash

mysql_version   = $1
rt_password     = $2
db_username     = $3
db_password     = $4
db_name         = $5
db_name_test    = $6

# Install MySQL
apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $rt_password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $rt_password"

apt-get -y install mysql-server

# Create the database and grant privileges
CMD="sudo mysql -uroot -p$rt_password -e"

$CMD "CREATE DATABASE IF NOT EXISTS $db_name"
$CMD "CREATE DATABASE IF NOT EXISTS $db_name_test"
$CMD "CREATE USER '$db_username@%' IDENTIFIED BY '$db_password';"
$CMD "GRANT ALL PRIVILEGES ON *.* TO '$db_username@%';"
$CMD "FLUSH PRIVILEGES;"

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart
