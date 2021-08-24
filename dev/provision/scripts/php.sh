#!/bin/bash

sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php8.0 php8.0-mysql

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/8.0/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/8.0/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/8.0/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/8.0/apache2/php.ini

sudo service apache2 restart
