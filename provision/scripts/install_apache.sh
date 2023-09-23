#!/bin/sh

# 04 Install Apache

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Installing Apache                               #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

export DEBIAN_FRONTEND=noninteractive

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

apt-get -qy install apache2
apt-get -qy install apache2-bin
apt-get -qy install apache2-data
apt-get -qy install apache2-utils

yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/html/index.htm /var/www/html/
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

sudo chmod -R 755 /var/www/html/*

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

service apache2 restart
