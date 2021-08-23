#!/bin/bash

apt-get update
apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common
add-apt-repository ppa:ondrej/php
