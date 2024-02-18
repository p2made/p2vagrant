#!/bin/zsh

# provision/scripts/vm_common.sh

# Usage...
# `source ./relative/path/to/vm_common.sh"`

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

# Function for error handling
# Usage: handle_error "Error message"
function handle_error() {
	echo "⚠️   Error: $1 💥"
	echo "Run 'vagrant halt' then restore the last snapshot before trying again."
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success() {
	icon="✅"

	if [ -n "$2" ] && [ "$2" -eq 1 ]; then
		icon="👍"
	fi

	echo "$icon  $1"
}

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job() {
	echo "👍  $1"
}

function debug_message() {
	echo "‼️‼️  Debug: $1 🚨"
}
