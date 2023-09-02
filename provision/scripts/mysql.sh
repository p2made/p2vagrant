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
