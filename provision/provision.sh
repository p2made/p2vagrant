#!/bin/bash

apt-get update
apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common
add-apt-repository ppa:ondrej/php

apt-get update
apt-get install -y apache2 mysql-server php8.0 php8.0-mysql
#sudo service apache2 restart
systemctl reload apache2
