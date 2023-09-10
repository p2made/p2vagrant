#!/bin/bash

# 05 Install phpMyAdmin

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### #####"
echo "##### #####       Installing phpMyAdmin"
echo "##### #####"
echo "##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### #####"

#PHPMYADMIN_VERSION  = $1 = "5.2.1"
#PMA_PASSWORD        = $2 = "PM4Passw0rd"
#REMOTE_FOLDER       = $3 = "/var/www"

LC_ALL=C.UTF-8 add-apt-repository ppa:phpmyadmin/ppa

apt-get update

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

apt-get install -y phpmyadmin

rm -rf /usr/share/phpmyadmin
#sudo mv /usr/share/phpmyadmin $3/html/phpmyadmin

cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/$1/phpMyAdmin-$1-all-languages.zip
unzip phpMyAdmin-$1-all-languages.zip
rm phpMyAdmin-$1-all-languages.zip
mv phpMyAdmin-$1-all-languages $3/html/phpmyadmin

chmod -R 755 $3/html/phpmyadmin

phpenmod mbstring

systemctl restart apache2
