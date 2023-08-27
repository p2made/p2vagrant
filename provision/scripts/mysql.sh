#!/bin/bash

# 05 Install MySQL 8.1

#MYSQL_VERSION   = $1
#RT_PASSWORD     = $2
#DB_USERNAME     = $3
#DB_PASSWORD     = $4
#DB_NAME         = $5
#DB_NAME_TEST    = $6

# Install MySQL
apt-get update
apt-get -y install mysql-server

service mysql restart
