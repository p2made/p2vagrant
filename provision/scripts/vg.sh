#!/bin/zsh

# vg.sh
# Updated: 2024-02-10

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
# Usage: read_and_parse_data step_title $vm_step $data_file
read_and_parse_data() {
	declare -n ret=$1
	local vm_step=$2
	local file_temp=$3

	while IFS= read -r one_line; do
		# Skip lines starting with #
		[[ "$one_line" =~ ^# ]] && continue

		local split_line
		split_line=(${(s:|:)one_line})  # Split the line by |

		if [[ "${split_line[1]}" -eq "$vm_step" ]]; then
			ret="${split_line[2]}"
			announce_success "Generating Vagrantfile for $vm_step: $step_title."
			return 0  # Valid step found in the data file
		fi
	done < "$file_temp"

	handle_error "Step not found in the data file"
}

# Function to set the Vagrantfile header
# Usage: set_header_lines file_parts $vm_step $step_title
set_header_lines () {
	declare -n ret=$1
	local i=$(printf "%02d" $2)
	local title=$3

	# Add the Vagrantfile header to the file_parts array
	ret+=( "# -*- mode: ruby -*-" )
	ret+=( "# vi: set ft=ruby" )
	ret+=( "" )
	ret+=( "# $i $title" )
	ret+=( "# Generated: $(date "+%Y-%m-%d")" )
	ret+=( "" )
	ret+=( "# Machine Variables" )
	ret+=( "VM_HOSTNAME         = \"$VM_HOSTNAME\"" )
	ret+=( "VM_IP               = \"$VM_IP\"" )
	ret+=( "TIMEZONE            = \"$TIMEZONE\"" )
	ret+=( "MEMORY              = $MEMORY" )
	ret+=( "CPUS                = $CPUS" )
}

# Function to set the Vagrantfile variable lines
# Usage: set_variables_lines file_parts $vm_step
set_variables_lines () {
	declare -n ret=$1
	local i=$2

	ret+=( "" )
	ret+=( "# Synced Folders" )
	ret+=( "HOST_FOLDER         = \"$HOST_FOLDER\"" )
	ret+=( "REMOTE_FOLDER       = \"$REMOTE_FOLDER\"" )

	if (( i >= 6 )); then
		ret+=( "" )
		ret+=( "# Software Versions" )
		ret+=( "PHP_VERSION         = \"$PHP_VERSION\"" )
	fi
	if (( i >= 7 )); then
		ret+=( "MYSQL_VERSION       = \"$MYSQL_VERSION\"" )
	fi
	if (( i >= 10 )); then
		ret+=( "SWIFT_VERSION       = \"$SWIFT_VERSION\"" )
	fi
	if (( i >= 7 )); then
		ret+=( "" )
		ret+=( "# Database Variables" )
		ret+=( "ROOT_PASSWORD       = \"$ROOT_PASSWORD\"" )
		ret+=( "DB_USERNAME         = \"$DB_USERNAME\"" )
		ret+=( "DB_PASSWORD         = \"$DB_PASSWORD\"" )
		ret+=( "DB_NAME             = \"$DB_NAME\"" )
		ret+=( "DB_NAME_TEST        = \"$DB_NAME_TEST\"" )
	fi
}

# Function to set VM config opening lines
# Usage: set_config_opening_lines file_parts
set_config_opening_lines () {
	declare -n ret=$1

	ret+=( "" )
	ret+=( 'Vagrant.configure("2") do |config|' )
	ret+=( "" )
	ret+=( "\tconfig.vm.box = \"bento/ubuntu-20.04-arm64\"" )
	ret+=( "" )
	ret+=( "\tconfig.vm.provider \"vmware_desktop\" do |v|" )
	ret+=( "\t\tv.memory    = MEMORY" )
	ret+=( "\t\tv.cpus      = CPUS" )
	ret+=( "\t\tv.gui       = true" )
	ret+=( "\tend" )
	ret+=( "" )
	ret+=( "\t# Configure network..." )
	ret+=( "\tconfig.vm.network \"private_network\", ip: VM_IP" )
	ret+=( "" )
	ret+=( "\t# Set a synced folder..." )
	ret+=( "\tconfig.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: [\"actimeo=2\"]" )
}

# Function to set the comment on a VM config provisioning line
# Usage: set_config_provisioning_lines file_parts $prov_temp $i $n
set_provisioning_line () {
	declare -n ret=$1
	local prov_string=$2

	if (( $3 > $4 )); then
		prov_string="#$prov_string"
	fi

	ret+=( "$prov_string" )
}

# Function to set VM config provisioning lines
# Usage: set_config_provisioning_lines file_parts $vm_step
set_config_provisioning_lines () {
	declare -n ret=$1
	local i=$2
	local n

	if (( i >= 4 )); then
		ret+=( "" )
		ret+=( "# Upgrade check..." )
		ret+=( 'config.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", args: [VM_HOSTNAME], run: "always"' )
	fi
	if (( i >= 2 )); then
		ret+=( "" )
		ret+=( "# Provisioning..." )
	fi

	prov_temp='\tconfig.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]'
	n=2
	set_provisioning_line file_parts $prov_temp $i $n
}

# Function to set VM config closing lines
# Usage: set_config_closing_lines file_parts
set_config_closing_lines () {
	ret+=( "" )
	ret+=( "end" )
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

read_and_parse_data step_title $vm_step $data_file

set_header_lines file_parts $vm_step $step_title
set_variables_lines file_parts $vm_step
set_config_opening_lines file_parts
set_config_provisioning_lines file_parts $vm_step
set_config_closing_lines file_parts

# Write file_parts to a file (e.g., Vagrantfile_test) with line breaks and actual tabs
printf "%s\n" "${file_parts[@]}" | sed 's/\\t/'$'\t'/g > ./Vagrantfile
