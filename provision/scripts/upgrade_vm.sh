#!/bin/sh

# 02 Upgrade VM

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Upgrading VM                                    #####"
echo "#####                                                       #####"
echo "#####       should always run first                         #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

export DEBIAN_FRONTEND=noninteractive

apt-get -q update
apt-get -qy upgrade
apt-get autoremove
cat /etc/os-release
