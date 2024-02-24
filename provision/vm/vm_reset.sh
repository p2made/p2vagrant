#!/bin/zsh

# provision/vm/vm_reset.sh

# Usage:
# `./provision/vm/vm_reset.sh "$(pwd)" "$passed_step"`

# Common functions
source ./provision/vm/vm_common.sh

# Source data
source ./provision/data/vm_data.sh

# Change working directory to the 'vm' directory
cd "$1"

# Access the value of $provisioning_step passed as an argument
provisioning_step=$2

# Function to display a map of files to be deleted
function construct_reset_map() {
	echo "Files to be deleted:"

	local -a html
	local -a provision_html
	local -a provision_ssl
	local -a provision_vhosts

	if (( $provisioning_step <= 9 )); then
		# Resetting from configuring websites
		provision_ssl+=(
			$(find ./provision/ssl -maxdepth 1 -type f -name '*.cert' -not -name '*p2vagrant*')
			$(find ./provision/ssl -maxdepth 1 -type f -name '*.key' -not -name '*p2vagrant*')
		)
		provision_vhosts+=(
			$(find ./provision/vhosts -maxdepth 1 -type f -name '*.conf' -not -name '*p2vagrant*' -not -name 'local.conf')
		)
		for tld in "${VM_TLDS[@]}"; do
			domains_to_delete+=(
				$(find ./ -maxdepth 1 -type d -name "${tld}_*")
			)
		done
	else
		# '$provisioning_step' won't be <= any smaller value
		return
	fi

	if (( $provisioning_step <= 8 )); then
		# Resetting from installing phpMyAdmin
		html+=(
			$(find ./html -maxdepth 1 -type d -name 'phpmyadmin')
		)
	else
		# '$provisioning_step' won't be <= any smaller value
		return
	fi

	if (( $provisioning_step <= 7 )); then
		# Resetting from installing MySQL
		html+=(
			$(find ./html -maxdepth 1 -type f -name 'db.php')
		)
		provision_html+=(
			$(find ./provision/html -maxdepth 1 -type f -name 'db.php')
		)
	else
		# '$provisioning_step' won't be <= any smaller value
		return
	fi

	if (( $provisioning_step <= 6 )); then
		# Resetting from installing php
		html+=(
			$(find ./html -maxdepth 1 -type f -name 'index.php')
			$(find ./html -maxdepth 1 -type f -name 'phpinfo.php')
		)
		provision_html+=(
			$(find ./provision/html -maxdepth 1 -type f -name 'index.php')
		)
	else
		# '$provisioning_step' won't be <= any smaller value
		return
	fi

	if (( $provisioning_step <= 5 )); then
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
	else
		# '$provisioning_step' won't be <= any smaller value
		return
	fi

	files_to_delete=(
		"${html[@]}"
		"${provision_html[@]}"
		"${provision_ssl[@]}"
		"${provision_vhosts[@]}"
	)
}

# Function to delete files
# Usage: delete_files "${files_to_delete[@]}"
function delete_files() {
	rm -f "${@}"
}

# Function to delete folders
# Usage: delete_files "${domains_to_delete[@]}"
function delete_folders() {
	rm -rf "${@}"

	# Specific deletion for phpmyadmin folder if it exists
	if [ -d "./html/phpmyadmin" ]; then
		rm -rf "./html/phpmyadmin"
	fi
}

# Function to prompt for confirmation
function confirm_reset() {
	declare -a files_to_delete
	declare -a domains_to_delete

	construct_reset_map

	# Display the found files
	for file in "${files_to_delete[@]}"; do
		echo "$file" | sed "s|^./|p2vagrant/|"
	done
	for file in "${domains_to_delete[@]}"; do
		echo "$file" | sed "s|^./|p2vagrant/|"
	done

	read "?Warning: This will delete any generated or copied files. Are you sure? (Y/n): " answer
	case $answer in
		[Y])
			# Call a function to delete the files
			delete_files "${files_to_delete[@]}"
			delete_folders "${domains_to_delete[@]}"
			;;
		*)
			echo "Reset operation canceled."
			exit 0
			;;
	esac
}
