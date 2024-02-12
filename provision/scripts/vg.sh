#!/bin/zsh

# vg.sh
# Updated: 2024-02-11

# Generates Vagrantfile for the step specified by an integer argument.

# Machine Variables
VM_HOSTNAME="p2vagrant"
VM_IP="192.168.22.42"                   # 22 = titanium, 42 = Douglas Adams's number
TIMEZONE="Australia/Brisbane"           # "Europe/London"
MEMORY=4096
CPUS=1

# Synced Folders
HOST_FOLDER="."
REMOTE_FOLDER="/var/www"

# Software Versions
PHP_VERSION="8.3"
MYSQL_VERSION="8.1"
SWIFT_VERSION="5.9.2"                   # For installing Swift (optional)

# Database Variables
ROOT_PASSWORD="RootPassw0rd"
DB_USERNAME="fredspotty"
DB_PASSWORD="Passw0rd"
DB_NAME="example_db"
DB_NAME_TEST="example_db_test"

# Vagrantfile data...
data_file="./provision/data/vagrant_data"

# Argument...
vm_step=$1

# Script variables...
step_title=""
file_parts=()

# Sparse array of provisioning script calls, indexed by setup step...
provisioning_indexes=(2 3 5 6 7 8 10)
provisioning_items[2]='\tconfig.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]'
provisioning_items[3]='\tconfig.vm.provision :shell, path: "provision/scripts/install_utilities.sh"'
provisioning_items[5]='\tconfig.vm.provision :shell, path: "provision/scripts/install_swift.fish", args: [SWIFT_VERSION]'
provisioning_items[6]='\tconfig.vm.provision :shell, path: "provision/scripts/install_apache.fish"'
provisioning_items[7]='\tconfig.vm.provision :shell, path: "provision/scripts/install_php.fish", args: [PHP_VERSION]'
provisioning_items[8]='\tconfig.vm.provision :shell, path: "provision/scripts/install_mysql.fish", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]'
provisioning_items[10]='\tconfig.vm.provision :shell, path: "provision/scripts/configure_sites.fish"'

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function for error handling
# Usage: handle_error "Error message"
handle_error() {
	echo "⚠️ Error: $1 💥"
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

# Function to read and parse the data file
# Usage: read_and_parse_data $vm_step $data_file
read_and_parse_data() {
	local vm_step=$1
	local file_temp=$2

	while IFS= read -r one_line; do
		# Skip lines starting with #
		[[ "$one_line" =~ ^# ]] && continue

		split_line=(${(s:|:)one_line})  # Split the line by |

		if [[ "${split_line[1]}" -eq "$vm_step" ]]; then
			step_title="${split_line[2]}"
			announce_success "Generating Vagrantfile for $vm_step: $step_title."
			return 0  # Valid step found in the data file
		fi
	done < "$file_temp"

	handle_error "Step not found in the data file"
}

# Function to set the Vagrantfile header
# Usage: set_header_lines $vm_step $step_title
set_header_lines () {
	local i=$(printf "%02d" $1)
	local title=$2

	# Add the Vagrantfile header to the file_parts array
	file_parts+=( "# -*- mode: ruby -*-" )
	file_parts+=( "# vi: set ft=ruby" )
	file_parts+=( "" )
	file_parts+=( "# $i $title" )
	file_parts+=( "# Generated: $(date "+%Y-%m-%d")" )
	file_parts+=( "" )
	file_parts+=( "# Machine Variables" )
	file_parts+=( "VM_HOSTNAME         = \"$VM_HOSTNAME\"" )
	file_parts+=( "VM_IP               = \"$VM_IP\"" )
	file_parts+=( "TIMEZONE            = \"$TIMEZONE\"" )
	file_parts+=( "MEMORY              = $MEMORY" )
	file_parts+=( "CPUS                = $CPUS" )
}

# Function to set the Vagrantfile variable lines
# Usage: set_variables_lines $vm_step
set_variables_lines () {
	local step_idx=$1

	file_parts+=( "" )
	file_parts+=( "# Synced Folders" )
	file_parts+=( "HOST_FOLDER         = \"$HOST_FOLDER\"" )
	file_parts+=( "REMOTE_FOLDER       = \"$REMOTE_FOLDER\"" )

	if (( i >= 6 )); then
		file_parts+=( "" )
		file_parts+=( "# Software Versions" )
		file_parts+=( "PHP_VERSION         = \"$PHP_VERSION\"" )
	fi
	if (( i >= 7 )); then
		file_parts+=( "MYSQL_VERSION       = \"$MYSQL_VERSION\"" )
	fi
	if (( i >= 10 )); then
		file_parts+=( "SWIFT_VERSION       = \"$SWIFT_VERSION\"" )
	fi
	if (( i >= 7 )); then
		file_parts+=( "" )
		file_parts+=( "# Database Variables" )
		file_parts+=( "ROOT_PASSWORD       = \"$ROOT_PASSWORD\"" )
		file_parts+=( "DB_USERNAME         = \"$DB_USERNAME\"" )
		file_parts+=( "DB_PASSWORD         = \"$DB_PASSWORD\"" )
		file_parts+=( "DB_NAME             = \"$DB_NAME\"" )
		file_parts+=( "DB_NAME_TEST        = \"$DB_NAME_TEST\"" )
	fi
}

# Function to set VM config opening lines
# Usage: set_config_opening_lines
set_config_opening_lines () {
	file_parts+=( "" )
	file_parts+=( 'Vagrant.configure("2") do |config|' )
	file_parts+=( "" )
	file_parts+=( "\tconfig.vm.box = \"bento/ubuntu-20.04-arm64\"" )
	file_parts+=( "" )
	file_parts+=( "\tconfig.vm.provider \"vmware_desktop\" do |v|" )
	file_parts+=( "\t\tv.memory    = MEMORY" )
	file_parts+=( "\t\tv.cpus      = CPUS" )
	file_parts+=( "\t\tv.gui       = true" )
	file_parts+=( "\tend" )
	file_parts+=( "" )
	file_parts+=( "\t# Configure network..." )
	file_parts+=( "\tconfig.vm.network \"private_network\", ip: VM_IP" )
	file_parts+=( "" )
	file_parts+=( "\t# Set a synced folder..." )
	file_parts+=( "\tconfig.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: [\"actimeo=2\"]" )
}

# Function to set VM config provisioning lines
# Usage: set_provisioning_lines $vm_step
set_provisioning_lines () {
	local step_idx=$1

	if (( i >= 4 )); then
		file_parts+=( "" )
		file_parts+=( "\t# Upgrade check..." )
		file_parts+=( '\tconfig.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", args: [VM_HOSTNAME], run: "always"' )
	fi

	if (( i >= 2 )); then
		file_parts+=( "" )
		file_parts+=( "\t# Provisioning..." )

		# Loop through keys of the associative array in sorted order
		for prov_idx in "${provisioning_indexes[@]}"; do
			prov_string=$provisioning_items[$prov_idx]
			if (( $step_idx <= $prov_idx )); then
				if (( $step_idx == $prov_idx )); then
					file_parts+="$prov_string"
				fi
				return
			fi
			file_parts+=( "#$prov_string" )
		done
	fi
}

# Function to set VM config closing lines
# Usage: set_config_closing_lines
set_config_closing_lines () {
	file_parts+=( "" )
	file_parts+=( "end" )
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

read_and_parse_data $vm_step $data_file

set_header_lines $vm_step $step_title
set_variables_lines $vm_step
set_config_opening_lines
set_provisioning_lines $vm_step
set_config_closing_lines

# Write file_parts to a file (e.g., Vagrantfile_test) with line breaks and actual tabs
printf "%s\n" "${file_parts[@]}" | sed 's/\\t/'$'\t'/g > ./Vagrantfile
