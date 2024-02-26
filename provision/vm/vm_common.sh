#!/bin/zsh

# provision/vm/vm_common.sh

# Usage:
# `source ./relative/path/to/vm_common.sh`

# Script constants

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
PROVISIONING_ITEMS[3]='config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [VM_HOSTNAME, TIMEZONE]'
PROVISIONING_ITEMS[4]='config.vm.provision :shell, path: "provision/scripts/install_swift.sh", args: [SWIFT_VERSION]'
PROVISIONING_ITEMS[5]='config.vm.provision :shell, path: "provision/scripts/install_apache.sh"'
PROVISIONING_ITEMS[6]='config.vm.provision :shell, path: "provision/scripts/install_php.sh", args: [PHP_VERSION]'
PROVISIONING_ITEMS[7]='config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]'
PROVISIONING_ITEMS[9]='config.vm.provision :shell, path: "provision/scripts/configure_sites.sh"'

# Function for error handling
# Usage: handle_error "Message"
function handle_error() {
	echo "⚠️   Error: $1 💥"
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success() {
	icon="✅"

	if [ "$2" -eq 1 ]; then
		icon="👍"
	fi

	echo "$icon  $1"
}

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job() {
	echo "👍  $1"
}

# Function to give a debugging message
# Usage: debug_message "$LINENO" "Message"
function debug_message() {
	local calling_function="${FUNCNAME[1]}"
	echo "‼️‼️  Debug in $calling_function at line $1: $2 🚨"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to write update banner
# Usage: vm_application_banner
function vm_application_banner() {
	cat "./provision/vm/txt/art_flags.txt"
	cat "./provision/vm/txt/art_ua.txt"
	cat "./provision/vm/txt/art_p2vagrant.txt"
	cat "./provision/vm/txt/art_ua.txt"
	cat "./provision/vm/txt/art_manager.txt"
	cat "./provision/vm/txt/art_ua.txt"
	cat "./provision/vm/txt/art_copyright.txt"
	cat "./provision/vm/txt/art_ua.txt"
	cat "./provision/vm/txt/art_peace_$(( RANDOM % 4 )).txt"
	cat "./provision/vm/txt/art_ua.txt"
	cat "./provision/vm/txt/art_flags.txt"
	echo ""
}
