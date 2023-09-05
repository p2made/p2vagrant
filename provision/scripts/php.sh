#!/bin/bash

# 02 Install PHP 8.2

#PHP_VERSION         = $1 = 8.2

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

apt-get update
apt-get install -y php$1 php-common
apt-get install -y php$1-{mysql,bcmath,fpm,xml,mysql,zip,intl,ldap,gd,cli,bz2,curl,mbstring,pgsql,opcache,soap,cgi,common,dom,imagick}

php -v
php -m
