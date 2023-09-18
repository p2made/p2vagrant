#!/bin/bash

# 00 Always - at beginning of VM load

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### #####"
echo -e "##### #####       Beginning of VM Loading"
echo -e "##### #####"
echo -e "##### #####       should always run"
echo -e "##### #####       should run first"
echo -e "##### #####"
echo -e "##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### #####\n"

echo -e "Update & upgrade..."
apt-get -q update
apt-get -qy upgrade
apt-get autoremove
cat /etc/os-release
