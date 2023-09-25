#!/bin/sh

# 08 Install phpMyAdmin

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Installing phpMyAdmin                           #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

export DEBIAN_FRONTEND=noninteractive

# PMA_VERSION         = "5.2.1"               | $1
# DB_PASSWORD         = "PM4Passw0rd"         | $2
# REMOTE_FOLDER       = "/var/www"            | $3

echo "LC_ALL=C.UTF-8 apt-add-repository -yu ppa:phpmyadmin/ppa"
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:phpmyadmin/ppa

echo "debconf-set-selections <<< \"phpmyadmin phpmyadmin/dbconfig-install boolean true\""
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
echo "debconf-set-selections <<< \"phpmyadmin phpmyadmin/app-password-confirm password $2\""
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $2"
echo "debconf-set-selections <<< \"phpmyadmin phpmyadmin/mysql/admin-pass password $2\""
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $2"
echo "debconf-set-selections <<< \"phpmyadmin phpmyadmin/mysql/app-pass password $2\""
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $2"
echo "debconf-set-selections <<< \"phpmyadmin phpmyadmin/reconfigure-webserver multiselect none\""
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

echo "apt-get -qy install phpmyadmin"
apt-get -qy install phpmyadmin

echo "rm -rf /usr/share/phpmyadmin"
rm -rf /usr/share/phpmyadmin

echo "cp -R $3/provision/html/phpmyadmin $3/html/phpmyadmin"
cp -R $3/provision/html/phpmyadmin $3/html/phpmyadmin

echo "sudo chmod -R 755 $3/html/phpmyadmin"
sudo chmod -R 755 $3/html/phpmyadmin

echo "sudo phpenmod mbstring"
sudo phpenmod mbstring
echo "service apache2 restart"
service apache2 restart
