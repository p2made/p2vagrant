#!/bin/sh

# 00 Always at Start of VM Loading

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "#####"
echo -e "#####       Starting VM Loading"
echo -e "#####"
echo -e "#####       should always run first"
echo -e "#####"
echo -e "##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### #####\n\n"

echo -e "Update & upgrade..."
apt-get -q update
apt-get -qy upgrade
apt-get autoremove
cat /etc/os-release
