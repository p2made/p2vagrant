#!/bin/bash

# 06 Install MySQL 8.1

apt-get update
apt-get install -y unzip

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

apt-get install -y phpmyadmin

rm -rf /usr/share/phpmyadmin

cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/$1/phpMyAdmin-$1-all-languages.zip
unzip phpMyAdmin-$1-all-languages.zip
rm phpMyAdmin-$1-all-languages.zip
sudo mv phpMyAdmin-$1-all-languages $3/html/phpmyadmin

#sudo chown -R www-data:www-data $3/html/phpmyadmin
sudo chmod -R 755 $3/html/phpmyadmin

phpenmod mbstring
systemctl restart apache2
