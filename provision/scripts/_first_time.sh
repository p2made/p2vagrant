#!/bin/bash

# first time VM is loaded

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### #####"
echo "##### #####       First Time Loading VM"
echo "##### #####"
echo "##### #####       should only run first time"
echo "##### #####"
echo "##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### #####"

#TIMEZONE            = $1    # "Australia/Brisbane"

echo "Configure timezone..."
timedatectl set-timezone $1 --no-ask-password

echo "Add repository for Fish shell..."
LC_ALL=C.UTF-8 apt-add-repository ppa:fish-shell/release-3

echo "Update & upgrade..."
apt-get update
apt-get -y upgrade
apt-get autoremove
cat /etc/os-release

echo "Install utilities..."
apt-get -y install apt-transport-https bzip2 ca-certificates curl expect file fish gnupg2 gzip libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap liblua5.3-0 lsb-release mime-support software-properties-common unzip

echo "Make Fish default..."
chsh -s /usr/bin/fish

echo "Set default shell location..."
echo 'cd /var/www' >> /home/vagrant/.profile
