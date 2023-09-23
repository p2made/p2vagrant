#!/bin/sh

# 02 Upgrade VM

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####"
echo "#####       Upgrade VM"
echo "#####"
echo "#####       should always run first"
echo "#####"
echo "##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### #####"
echo ""

echo "Update & upgrade..."
apt-get -q update
apt-get -qy upgrade
apt-get autoremove
cat /etc/os-release
