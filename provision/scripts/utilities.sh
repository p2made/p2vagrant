#!/bin/bash

# 01b Install Utilities

apt-get update

apt-get install -y apt-transport-https
apt-get install -y ca-certificates
apt-get install -y curl
apt-get install -y gnupg2
apt-get install -y lsb-release
apt-get install -y software-properties-common
apt-get install -y unzip
