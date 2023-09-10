#!/bin/bash

# 01a Upgrade

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### #####"
echo "##### #####       Upgrading VM"
echo "##### #####"
echo "##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### #####"

apt-get update

apt-get -y upgrade
apt-get autoremove

cat /etc/os-release
