#!/bin/bash

# 05 Install MySQL 8.1

#MYSQL_VERSION   = $1
#RT_PASSWORD     = $2
#DB_USERNAME     = $3
#DB_PASSWORD     = $4
#DB_NAME         = $5
#DB_NAME_TEST    = $6

# Install MySQL
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                 #####"
echo "#####            ¡¡¡ Installing MySQL !!!             #####"
echo "#####                                                 #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"

apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $2"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $2"

apt-get -y install mysql-server

echo "¡¡¡ Configuring MySQL..."

# Create the databases, create user, & grant privileges
#CMD="sudo mysql -uroot -p$2 -e"

#$CMD "CREATE USER '$3'@'%' IDENTIFIED BY '$4';"
#$CMD "CREATE DATABASE IF NOT EXISTS $5"
#$CMD "GRANT ALL PRIVILEGES ON $5.* TO '$3'@'%'"
#$CMD "CREATE DATABASE IF NOT EXISTS $6"
#$CMD "GRANT ALL PRIVILEGES ON $6.* TO '$3'@'%'"

#sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
#grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

#service mysql restart

echo "¡¡¡ MySQL Installation Complete !!!"






#!/bin/bash

# 05 Install MySQL 8.1

#MYSQL_VERSION   = $1
#RT_PASSWORD     = $2
#DB_USERNAME     = $3
#DB_PASSWORD     = $4
#DB_NAME         = $5
#DB_NAME_TEST    = $6

# Install MySQL
apt-get update
apt-get -y upgrade

debconf-set-selections <<< "mysql-server mysql-server/root_password password $2"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $2"

apt-get -y install mysql-server

# Create the databases, create user, & grant privileges
CMD = "sudo mysql -uroot -p$2 -e"

sudo mysql -uroot -p$2 -e "CREATE USER '$3'@'%' IDENTIFIED BY '$4';"
sudo mysql -uroot -p$2 -e "CREATE DATABASE IF NOT EXISTS $5"
sudo mysql -uroot -p$2 -e "GRANT ALL PRIVILEGES ON $5.* TO '$3'@'%'"
sudo mysql -uroot -p$2 -e "CREATE DATABASE IF NOT EXISTS $6"
sudo mysql -uroot -p$2 -e "GRANT ALL PRIVILEGES ON $6.* TO '$3'@'%'"

sudo mysql -uroot -p$2 -e "CREATE USER `$3`@`%` IDENTIFIED BY `$4`;"
sudo mysql -uroot -p$2 -e "CREATE DATABASE IF NOT EXISTS $5"
sudo mysql -uroot -p$2 -e "GRANT ALL PRIVILEGES ON $5.* TO `$3`@`%`"
sudo mysql -uroot -p$2 -e "CREATE DATABASE IF NOT EXISTS $6"
sudo mysql -uroot -p$2 -e "GRANT ALL PRIVILEGES ON $6.* TO `$3`@`%`"


CMD="sudo mysql -uroot -p$2 -e"

$CMD "CREATE USER '$3'@'%' IDENTIFIED BY '$4';"
$CMD "CREATE DATABASE IF NOT EXISTS $5"
$CMD "GRANT ALL PRIVILEGES ON $5.* TO '$3'@'%'"
$CMD "CREATE DATABASE IF NOT EXISTS $6"
$CMD "GRANT ALL PRIVILEGES ON $6.* TO '$3'@'%'"

$CMD "CREATE USER `$3`@`%` IDENTIFIED BY `$4`;"
$CMD "CREATE DATABASE IF NOT EXISTS $5"
$CMD "GRANT ALL PRIVILEGES ON $5.* TO `$3`@`%`"
$CMD "CREATE DATABASE IF NOT EXISTS $6"
$CMD "GRANT ALL PRIVILEGES ON $6.* TO `$3`@`%`"


sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart
