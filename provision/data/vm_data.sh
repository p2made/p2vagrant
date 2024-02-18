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
VAGRANTFILES_INDEXES=(1 2 3 4 5 6 7 9)
VAGRANTFILES[1]="Create Bare VM"
VAGRANTFILES[2]="Upgrade VM"
VAGRANTFILES[3]="Install Utilities"
VAGRANTFILES[4]="Install Swift (optional)"
VAGRANTFILES[5]="Install Apache (with SSL & Markdown)"
VAGRANTFILES[6]="Install PHP (with Composer)"
VAGRANTFILES[7]="Install MySQL"
VAGRANTFILES[9]="Configure Sites"

# Sparse array of provisioning script calls, indexed by setup step...
PROVISIONING_INDEXES=(3 4 5 6 7 9)
PROVISIONING_ITEMS[3]='	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [VM_HOSTNAME, TIMEZONE]'
PROVISIONING_ITEMS[4]='	config.vm.provision :shell, path: "provision/scripts/install_swift.sh", args: [SWIFT_VERSION]'
PROVISIONING_ITEMS[5]='	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"'
PROVISIONING_ITEMS[6]='	config.vm.provision :shell, path: "provision/scripts/install_php.sh", args: [PHP_VERSION]'
PROVISIONING_ITEMS[7]='	config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]'
PROVISIONING_ITEMS[9]='	config.vm.provision :shell, path: "provision/scripts/configure_sites.sh"'
