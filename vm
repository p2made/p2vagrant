#!/bin/zsh

# vm
# Updated: 2024-02-16

# Generates Vagrantfile for the step specified by an integer argument.
# &/or deletes previously generated & copied files

# Source data
source ./provision/data/vagrantfiles_data.sh

# Define flags
FLAG_GENERATE=false
FLAG_RESET=false

# Script variables
vm_step=0
step_title=""

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/     Utility Functions     /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function for error handling
# Usage: handle_error "Error message"
function handle_error() {
	echo "⚠️  Error: $1 💥"
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success() {
	icon="✅"

	if [ -n "$2" ] && [ "$2" -eq 1 ]; then
		icon="👍"
	fi

	echo "$icon $1"
}

# Function to display usage information
function display_usage() {
	script_name="$1"
	echo "Usage: $script_name [-g] [-r] <integer>"
	echo "Options:"
	echo "  -g    Generate Vagrantfile based on the specified integer."
	echo "  -r    Reset: Delete any generated or copied files from earlier Vagrant provisioning."
	echo "  <integer>   Step number for Vagrantfile generation."
	echo "--"
	echo "Usage examples:"
	echo "  $script_name -g <integer>    # Generate Vagrantfile based on the specified integer."
	echo "  $script_name -r              # Reset: Delete any generated or copied files from earlier Vagrant provisioning."
	echo "  $script_name -r <integer>    # Reset and generate Vagrantfile based on the specified integer."
	echo "  $script_name -gr <integer>   # Reset and generate Vagrantfile based on the specified integer."
	exit 0
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/        Reset Logic        /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to display a map of files to be deleted
function display_reset_map() {
	echo "Files to be deleted:"

	local -a html
	local -a provision_html
	local -a provision_ssl
	local -a provision_vhosts

	if [ $vm_step -le 9 ]; then
		# Resetting from configuring websites
		provision_ssl+=(
			$(find ./provision/ssl -maxdepth 1 -type f -name '*.cert' -not -name '*p2vagrant*')
			$(find ./provision/ssl -maxdepth 1 -type f -name '*.key' -not -name '*p2vagrant*')
		)
		provision_vhosts+=(
			$(find ./provision/vhosts -maxdepth 1 -type f -name '*.conf' -not -name '*p2vagrant*' -not -name 'local.conf')
		)
		domains_to_delete+=(
			$(find ./ -maxdepth 1 -type d -name "$VM_TLD*")
		)
	fi
	if [ $vm_step -le 8 ]; then
		# Resetting from installing phpMyAdmin
		html+=(
			$(find ./html -maxdepth 1 -type d -name 'phpmyadmin')
		)
	fi
	if [ $vm_step -le 7 ]; then
		# Resetting from installing MySQL
		html+=(
			$(find ./html -maxdepth 1 -type f -name 'db.php')
		)
		provision_html+=(
			$(find ./provision/html -maxdepth 1 -type f -name 'db.php')
		)
	fi
	if [ $vm_step -le 6 ]; then
		# Resetting from installing php
		html+=(
			$(find ./html -maxdepth 1 -type f -name 'index.php')
			$(find ./html -maxdepth 1 -type f -name 'phpinfo.php')
		)
		provision_html+=(
			$(find ./provision/html -maxdepth 1 -type f -name 'index.php')
		)
	fi
	if [ $vm_step -le 5 ]; then
		# Resetting from installing Apache - which is everything for this job!
		html+=(
			$(find ./html -maxdepth 1 -type f -name 'index.htm')
			$(find ./html -maxdepth 1 -type f -name 'index.html')
			$(find ./html -maxdepth 1 -type f -name 'index.md')
		)
		provision_html+=(
			$(find ./provision/html -maxdepth 1 -type f -name 'index.htm')
			$(find ./provision/html -maxdepth 1 -type f -name 'index.md')
		)
		provision_ssl=(
			$(find ./provision/ssl -maxdepth 1 -type f -name '*.cert')
			$(find ./provision/ssl -maxdepth 1 -type f -name '*.key')
		)
		provision_vhosts=(
			$(find ./provision/vhosts -maxdepth 1 -type f -name '*.conf')
		)
	fi

	files_to_delete=(
		"${html[@]}"
		"${provision_html[@]}"
		"${provision_ssl[@]}"
		"${provision_vhosts[@]}"
	)

	# Display the found files
	for file in "${files_to_delete[@]}"; do
		echo "$file" | sed "s|^./|p2vagrant/|"
	done
	for file in "${domains_to_delete[@]}"; do
		echo "$file" | sed "s|^./|p2vagrant/|"
	done
}

# Function to prompt for confirmation
function confirm_reset() {
	declare -a files_to_delete
	declare -a domains_to_delete

	display_reset_map

	read "?Warning: This will delete any generated or copied files. Are you sure? (y/n): " answer
	case $answer in
		[Yy]*)
			FLAG_RESET=true # we are here because FLAG_RESET is already set to true
			# Call a function to delete the files
			delete_files "${files_to_delete[@]}"
			delete_folders "${domains_to_delete[@]}"
			;;
		*)
			FLAG_RESET=false # Setting this is redundant because we are exiting
			echo "Reset operation canceled."
			exit 0
			;;
	esac
}

# Function to delete files
# Usage: delete_files "${files_to_delete[@]}"
function delete_files() {
	rm -f "${@}"
}

# Function to delete folders
# Usage: delete_files "${domains_to_delete[@]}"
function delete_folders() {
	rm -f "${@}"

	# Specific deletion for phpmyadmin folder if it exists
	if [ -d "./html/phpmyadmin" ]; then
		rm -rf "./html/phpmyadmin"
	fi
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/       Input Section       /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Process flags
while getopts ":gr" opt; do
	case $opt in
		g)
			FLAG_GENERATE=true
			;;
		r)
			FLAG_RESET=true
			;;
		\?)
			handle_error "Invalid option: -$OPTARG"
			;;
		:)
			handle_error "Option -$OPTARG requires an argument"
			;;
	esac
done

# Shift to the next argument after processing flags
shift $((OPTIND - 1))

# Check if there are no flags or arguments
if [ "$#" -eq 0 ] && ! $FLAG_RESET && ! $FLAG_GENERATE; then
	display_usage "$0"
fi

# Check if an argument is provided
if [ $# -gt 0 ]; then
	# Check if the argument is an integer
	if [[ $1 =~ ^[0-9]+$ ]]; then
		vm_step=$1
	else
		handle_error "$vm_step is not an integer"
	fi
fi

# If -r is set
if $FLAG_RESET; then
	confirm_reset

	if [ "$vm_step" -eq 0 ]; then
		# Not generating a Vagrantfile
		exit 0
	fi
fi

# If -g is set
if $FLAG_GENERATE; then
	# Do 'FLAG_GENERATE' stuff
	# taking 'vm_step' into account
fi

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/      _section_label_      /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

