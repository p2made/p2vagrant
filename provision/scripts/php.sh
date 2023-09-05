#!/bin/bash

# 02 Install PHP 8.2

#PHP_VERSION         = $1 = 8.2

apt-get install software-properties-common

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

apt-get update
apt-get install -y php$1 php$1-mysql
