#!/bin/zsh

# provision/scripts/vagrant_generate.sh
# Usage...
# `./provision/scripts/vagrant_generate.sh "$(pwd)" "$vm_step"`

# Source data
source ../data/vagrantfiles_data.sh

# Change working directory to the 'vm' directory
cd "$1"

# Access the value of $vm_step passed as an argument
vm_step=$2

# Script variables...
declare step_title

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function for error handling
# Usage: handle_error "Error message"
handle_error() {
	echo "⚠️  Error: $1 💥"
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
announce_success() {
	icon="✅"

	if [ -n "$2" ] && [ "$2" -eq 1 ]; then
		icon="👍"
	fi

	echo "$icon $1"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to get the step title from sparse array in data
# Usage: get_step_title $vm_step
function get_step_title () {
	if [[ -z ${vagrantfiles[$1]:-} ]]; then
		handle_error "Step does not require a new Vagrantfile, or is out of range of steps"
	fi

	local i=$(printf "%02d" $1)
	step_title=$vagrantfiles[$1]
	announce_success "Generating Vagrantfile for $i: $step_title."
}

# Function to set the Vagrantfile header
# Usage: set_header_lines $vm_step $step_title
function write_header_lines () {
	local i=$(printf "%02d" $1)
	local title=$2

	# Write the Vagrantfile header
	echo "# -*- mode: ruby -*-" > ./Vagrantfile
	echo "# vi: set ft=ruby" >> ./Vagrantfile
	echo "" >> ./Vagrantfile
	echo "# $i $title" >> ./Vagrantfile
	echo "# Generated: $(date "+%Y-%m-%d")" >> ./Vagrantfile
	echo "" >> ./Vagrantfile
	echo "# Machine Variables" >> ./Vagrantfile
	echo "VM_HOSTNAME         = \"$VM_HOSTNAME\"" >> ./Vagrantfile
	echo "VM_IP               = \"$VM_IP\"" >> ./Vagrantfile
	echo "TIMEZONE            = \"$TIMEZONE\"" >> ./Vagrantfile
	echo "MEMORY              = $MEMORY" >> ./Vagrantfile
	echo "CPUS                = $CPUS" >> ./Vagrantfile
}

# Function to set the Vagrantfile variable lines
# Usage: set_variables_lines $vm_step
function write_variables_lines () {
	local vm_step=$1

	echo "" >> ./Vagrantfile
	echo "# Synced Folders" >> ./Vagrantfile
	echo "HOST_FOLDER         = \"$HOST_FOLDER\"" >> ./Vagrantfile
	echo "VM_FOLDER           = \"$VM_FOLDER\"" >> ./Vagrantfile

	if (( vm_step >= 4 )); then
		echo "" >> ./Vagrantfile
		echo "# Software Versions" >> ./Vagrantfile
		echo "SWIFT_VERSION       = \"$SWIFT_VERSION\"" >> ./Vagrantfile
	fi
	if (( vm_step >= 6 )); then
		echo "PHP_VERSION         = \"$PHP_VERSION\"" >> ./Vagrantfile
	fi
	if (( vm_step >= 7 )); then
		echo "MYSQL_VERSION       = \"$MYSQL_VERSION\"" >> ./Vagrantfile
		echo "" >> ./Vagrantfile
		echo "# Database Variables" >> ./Vagrantfile
		echo "ROOT_PASSWORD       = \"$ROOT_PASSWORD\"" >> ./Vagrantfile
		echo "DB_USERNAME         = \"$DB_USERNAME\"" >> ./Vagrantfile
		echo "DB_PASSWORD         = \"$DB_PASSWORD\"" >> ./Vagrantfile
		echo "DB_NAME             = \"$DB_NAME\"" >> ./Vagrantfile
		echo "DB_NAME_TEST        = \"$DB_NAME_TEST\"" >> ./Vagrantfile
	fi
}

# Function to set VM config opening lines
# Usage: set_config_opening_lines
function write_config_opening_lines () {
	echo "" >> ./Vagrantfile
	echo "Vagrant.configure(\"2\") do |config|" >> ./Vagrantfile
	echo "" >> ./Vagrantfile
	echo "	config.vm.box = \"bento/ubuntu-20.04-arm64\"" >> ./Vagrantfile
	echo "" >> ./Vagrantfile
	echo "	config.vm.provider \"vmware_desktop\" do |v|" >> ./Vagrantfile
	echo "		v.memory    = MEMORY" >> ./Vagrantfile
	echo "		v.cpus      = CPUS" >> ./Vagrantfile
	echo "		v.gui       = true" >> ./Vagrantfile
	echo "	end" >> ./Vagrantfile
	echo "" >> ./Vagrantfile
	echo "	# Configure network..." >> ./Vagrantfile
	echo "	config.vm.network \"private_network\", ip: VM_IP" >> ./Vagrantfile
	echo "" >> ./Vagrantfile
	echo "	# Set a synced folder..." >> ./Vagrantfile
	echo "	config.vm.synced_folder HOST_FOLDER, VM_FOLDER, create: true, nfs: true, mount_options: [\"actimeo=2\"]" >> ./Vagrantfile
}

# Function to set VM config provisioning lines
# Usage: set_provisioning_lines $vm_step
function write_provisioning_lines () {
	local vm_step=$1

	if (( vm_step >= 2 )); then
		echo "" >> ./Vagrantfile
		echo "	# Upgrade check..." >> ./Vagrantfile
		echo '	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: "always"' >> ./Vagrantfile
	fi

	if (( vm_step >= 3 )); then
		echo "" >> ./Vagrantfile
		echo "	# Provisioning..." >> ./Vagrantfile

		# Loop through keys of the associative array in sorted order
		for prov_step in "${provisioning_indexes[@]}"; do
			prov_string=$provisioning_items[$prov_step]
			if (( $vm_step <= $prov_step )); then
				if (( $vm_step == $prov_step )); then
					echo "$prov_string" >> ./Vagrantfile
				fi
				return
			fi
			echo "#$prov_string" >> ./Vagrantfile
		done
	fi
}

# Function to set VM config closing lines
# Usage: set_config_closing_lines
function write_config_closing_lines () {
	echo "" >> ./Vagrantfile
	echo "end" >> ./Vagrantfile
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

get_step_title $vm_step

write_header_lines $vm_step $step_title
write_variables_lines $vm_step
write_config_opening_lines
write_provisioning_lines $vm_step
write_config_closing_lines
