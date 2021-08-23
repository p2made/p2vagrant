#!/bin/bash

apt-get update
apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common
add-apt-repository ppa:ondrej/php
add-apt-repository ppa:ondrej/apache2

# language bug workaround
apt-get install -y language-pack-en-base
export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8
apt-get install -y software-properties-common

apt-get update
apt-get install -y apache2 mysql-server php8.0 php8.0-mysql
#sudo service apache2 restart
systemctl reload apache2
