#!/bin/bash

# 00 always at beginning of VM load

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### #####"
echo "##### #####       Beginning of VM Loading"
echo "##### #####"
echo "##### #####       should always run"
echo "##### #####       should run first"
echo "##### #####"
echo "##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### #####"\n

echo "Update & upgrade..."
apt-get update
apt-get -y upgrade
apt-get autoremove
cat /etc/os-release
