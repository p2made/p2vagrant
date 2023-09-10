#!/bin/bash

# 01b Install Utilities

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### #####"
echo "##### #####       Installing Utilities"
echo "##### #####"
echo "##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### #####"

apt-add-repository ppa:fish-shell/release-3

apt-get update

apt-get install -y apt-transport-https bzip2 ca-certificates curl expect file fish gnupg2 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap liblua5.3-0 lsb-release mime-support software-properties-common unzip

# Make Fish default
chsh -s /usr/bin/fish
