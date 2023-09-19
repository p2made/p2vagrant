#!/bin/sh

# 03a Install Composer

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "#####"
echo -e "#####       Installing Composer"
echo -e "#####"
echo -e "##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### #####\n\n"

cd /tmp
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

php composer-setup.php
rm composer-setup.php

sudo mv composer.phar /usr/local/bin/composer
composer self-update

composer
