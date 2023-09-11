#!/bin/bash

# always as root

apt-get update

apt-get -y upgrade
apt-get autoremove

cat /etc/os-release

service php8.2-fpm restart
service apache2 restart
service mysql restart

# ---- ^ ---- ^ ---- ^ ---- ^ ---- ^ ----


