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

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:phpmyadmin/ppa

#temp
apt-get -qy install debconf-utils

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections

apt-get -qy install phpmyadmin

rm -rf /usr/share/phpmyadmin

cp -R $3/provision/html/phpmyadmin $3/html/phpmyadmin

sudo chmod -R 755 $3/html/phpmyadmin

sudo phpenmod mbstring
service apache2 restart