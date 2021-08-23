#!/bin/bash

sudo apt-get update
sudo apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common

# language bug workaround
sudo apt-get install -y language-pack-en-base
sudo export LC_ALL=en_AU.UTF-8
sudo export LANG=en_AU.UTF-8
sudo apt-get install -y software-properties-common
