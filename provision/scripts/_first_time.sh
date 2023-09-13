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
readonly VM_IP      = $2    # "5.2.1"

info "Configure timezone..."
timedatectl set-timezone ${$1} --no-ask-password

info "Add repository for Fish shell..."
apt-add-repository ppa:fish-shell/release-3

info "Update & upgrade..."
apt-get update
apt-get -y upgrade
apt-get autoremove
cat /etc/os-release

info "Install utilities..."
apt-get install -y apt-transport-https bzip2 ca-certificates curl expect file fish gnupg2 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap liblua5.4-0 lsb-release mime-support software-properties-common unzip

info "Make Fish default..."
chsh -s /usr/bin/fish

info "Set default shell location..."
echo 'cd /var/www' >> /home/vagrant/.profile
