#!/bin/bash

# 01 Install Utilities

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### #####"
echo -e "##### #####       Installing Utilities"
echo -e "##### #####"
echo -e "##### #####       should only run once"
echo -e "##### #####"
echo -e "##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### #####\n"

# TIMEZONE            = "Australia/Brisbane"  | $1

timedatectl set-timezone $1 --no-ask-password

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:fish-shell/release-3

apt-get -qy install apt-transport-https bzip2 ca-certificates curl expect file gnupg2 gzip libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap liblua5.3-0 lsb-release mime-support software-properties-common unzip fish

chsh -s /usr/bin/fish
echo 'cd /var/www' >> /home/vagrant/.profile
