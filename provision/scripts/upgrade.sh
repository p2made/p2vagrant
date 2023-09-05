#!/bin/bash

# 01a Upgrade

apt-get update
apt-get -y upgrade
apt-get autoremove

[ -f /var/run/reboot-required ] && reboot -f

cat /etc/os-release
