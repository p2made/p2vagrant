#!/bin/zsh

# vagrantfiles_data.sh
# Updated: 2024-02-13

# Data for Vagrantfil generation.

# Machine Variables
VM_HOSTNAME="p2vagrant"
VM_IP="192.168.22.42"                   # 22 = titanium, 42 = Douglas Adams's number
TIMEZONE="Australia/Brisbane"           # "Europe/London"
MEMORY=4096
CPUS=1

# Synced Folders
HOST_FOLDER="."
VM_FOLDER="/var/www"

# Software Versions
PHP_VERSION="8.3"
MYSQL_VERSION="8.3"
SWIFT_VERSION="5.9.2"                   # For installing Swift (optional)

# Database Variables
ROOT_PASSWORD="RootPassw0rd"
DB_USERNAME="fredspotty"
DB_PASSWORD="Passw0rd"
DB_NAME="example_db"
DB_NAME_TEST="example_db_test"

# Sparse array of Vagrantfiles, indexed by setup step...
vagrantfiles[1]="Create Bare VM"
vagrantfiles[2]="Upgrade VM"
vagrantfiles[3]="Install Utilities"
vagrantfiles[4]="Install Swift (optional)"
vagrantfiles[5]="Install Apache (with SSL & Markdown)"
vagrantfiles[6]="Install PHP (with Composer)"
vagrantfiles[7]="Install MySQL"
vagrantfiles[9]="Configure Sites"
