#!/bin/bash

apt-get update
apt-get install -y apache2

sudo apt-get install software-properties-common
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.4 php7.4-bcmath php7.4-bz2 php7.4-cli php7.4-curl php7.4-intl php7.4-json php7.4-mbstring php7.4-opcache php7.4-soap php7.4-xml php7.4-xsl php7.4-zip libapache2-mod-php7.4

sudo service apache2 restart
