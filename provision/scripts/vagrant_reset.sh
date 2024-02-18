#!/bin/zsh

# provision/scripts/vagrant_reset.sh
# Usage...
# `./provision/scripts/vagrant_reset.sh "$(pwd)" "$vm_step"`

# Source data
source ../data/vagrantfiles_data.sh
source ./_common.sh

# Change working directory to the 'vm' directory
cd "$1"

# Access the value of $vm_step passed as an argument
vm_step=$2

# Function to display a map of files to be deleted
function construct_reset_map() {
	echo "Files to be deleted:"

	local -a html
	local -a provision_html
	local -a provision_ssl
	local -a provision_vhosts

	if (( $vm_step <= 9 )); then
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
		# '$vm_step' won't be <= any smaller value
		return
	fi

	if (( $vm_step <= 8 )); then
		# Resetting from installing phpMyAdmin
		html+=(
			$(find ./html -maxdepth 1 -type d -name 'phpmyadmin')
		)
	else
		# '$vm_step' won't be <= any smaller value
		return
	fi

	if (( $vm_step <= 7 )); then
		# Resetting from installing MySQL
		html+=(
			$(find ./html -maxdepth 1 -type f -name 'db.php')
		)
		provision_html+=(
			$(find ./provision/html -maxdepth 1 -type f -name 'db.php')
		)
	else
		# '$vm_step' won't be <= any smaller value
		return
	fi

	if (( $vm_step <= 6 )); then
		# Resetting from installing php
		html+=(
			$(find ./html -maxdepth 1 -type f -name 'index.php')
			$(find ./html -maxdepth 1 -type f -name 'phpinfo.php')
		)
		provision_html+=(
			$(find ./provision/html -maxdepth 1 -type f -name 'index.php')
		)
	else
		# '$vm_step' won't be <= any smaller value
		return
	fi

	if (( $vm_step <= 5 )); then
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
		# '$vm_step' won't be <= any smaller value
		return
	fi

	files_to_delete=(
		"${html[@]}"
		"${provision_html[@]}"
		"${provision_ssl[@]}"
		"${provision_vhosts[@]}"
	)
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
