#!/bin/sh

# 01 Install Utilities

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "#####"
echo -e "#####       Installing Utilities"
echo -e "#####"
echo -e "##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### #####\n\n"

# TIMEZONE            = "Australia/Brisbane"  | $1

timedatectl set-timezone $1 --no-ask-password

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:fish-shell/release-3

apt-get -qy install apt-transport-https
apt-get -qy install bzip2
apt-get -qy install ca-certificates
apt-get -qy install curl
apt-get -qy install expect
apt-get -qy install file
apt-get -qy install fish
apt-get -qy install git
apt-get -qy install gnupg2
apt-get -qy install gzip
apt-get -qy install libapr1
apt-get -qy install libaprutil1
apt-get -qy install libaprutil1-dbd-sqlite3
apt-get -qy install libaprutil1-ldap
apt-get -qy install liblua5.3-0
apt-get -qy install lsb-release
apt-get -qy install mime-support
apt-get -qy install software-properties-common
apt-get -qy install unzip

chsh -s /usr/bin/fish
echo 'cd /var/www' >> /home/vagrant/.profile
