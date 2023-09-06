#!/bin/bash

# 01b Install Utilities

apt-get update

apt-get install -y lsb-release gnupg2 ca-certificates apt-transport-https unzip
apt-get install software-properties-common -y
