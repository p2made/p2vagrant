#!/bin/bash

# 03 Install PHP 8.2

#PHP_VERSION         = $1 = 8.2

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

apt-get update
apt-get install -y php$1 php-common
apt-get install -y php$1-{bcmath,bz2,cgi,cli,common,curl,dom,exif,fileinfo,filter,fpm,gd,hash,iconv,imagick,imap,intl,json,ldap,mbstring,mcrypt,mysql,mysqli,opcache,openssl,pcre,pgsql,pspell,readline,simplexml,soap,sodium,xml,xmlreader,xmlrpc,zip,zlib}
apt-get install -y php-pear libapache2-mod-php$1

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/$1/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$1/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/$1/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$1/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/' /etc/php/$1/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/$1/apache2/php.ini

a2enmod php$1

#service apache2 restart
systemctl restart apache2

php -v
php -m
