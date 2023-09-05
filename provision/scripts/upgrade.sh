#!/bin/bash

apt-get update
apt-get -y upgrade
apt-get autoremove

[ -f /var/run/reboot-required ] &amp;&amp; reboot -f

cat /etc/os-release
