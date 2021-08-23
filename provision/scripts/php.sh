#!/bin/bash

sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php8.0 php8.0-mysql

sudo service apache2 restart
