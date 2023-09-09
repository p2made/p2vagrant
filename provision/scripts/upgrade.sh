#!/bin/bash

# 01a Upgrade

apt-get update

apt-get -y upgrade
apt-get autoremove

cat /etc/os-release
