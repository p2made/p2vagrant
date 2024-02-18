#!/bin/zsh

# vagrantfiles_data.sh
# Updated: 2024-02-15

# Data for Vagrantfil generation.

VM_TLDS=(
	"test"                              # One line for every dev TLD used
)

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

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/           ¡¡¡ DO NOT EDIT BELOW !!! /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Sparse array of Vagrantfiles, indexed by setup step...
vagrantfiles_indexes=(1 2 3 4 5 6 7 9)
vagrantfiles[1]="Create Bare VM"
vagrantfiles[2]="Upgrade VM"
vagrantfiles[3]="Install Utilities"
vagrantfiles[4]="Install Swift (optional)"
vagrantfiles[5]="Install Apache (with SSL & Markdown)"
vagrantfiles[6]="Install PHP (with Composer)"
vagrantfiles[7]="Install MySQL"
vagrantfiles[9]="Configure Sites"

# Sparse array of provisioning script calls, indexed by setup step...
provisioning_indexes=(3 4 5 6 7 9)
provisioning_items[3]='	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [VM_HOSTNAME, TIMEZONE]'
provisioning_items[4]='	config.vm.provision :shell, path: "provision/scripts/install_swift.sh", args: [SWIFT_VERSION]'
provisioning_items[5]='	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"'
provisioning_items[6]='	config.vm.provision :shell, path: "provision/scripts/install_php.sh", args: [PHP_VERSION]'
provisioning_items[7]='	config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]'
provisioning_items[9]='	config.vm.provision :shell, path: "provision/scripts/configure_sites.sh"'
