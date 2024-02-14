#!/bin/bash

# _common.sh

# Script constants...
TODAYS_DATE=$(env TZ=Australia/Brisbane date "+%Y-%m-%d")
VM_FOLDER=/var/www
SHARED_HTML=$VM_FOLDER/html
PROVISION_FOLDER=$VM_FOLDER/provision
PROVISION_DATA=$VM_FOLDER/provision/data
PROVISION_HTML=$VM_FOLDER/provision/html
PROVISION_LOGS=$VM_FOLDER/provision/logs
PROVISION_SCRIPTS=$VM_FOLDER/provision/scripts
PROVISION_SSL=$VM_FOLDER/provision/ssl
PROVISION_TEMPLATES=$VM_FOLDER/provision/templates
PROVISION_VHOSTS=$VM_FOLDER/provision/vhosts
VM_LOGS_FOLDER=$VM_FOLDER/vm_logs

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/          Utility Functions          /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function for error handling
# Usage: handle_error "Error message"
function handle_error() {
	echo "⚠️  Error: $1 💥"
	echo "Run `vagrant halt` then restore the last snapshot before trying again."
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

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job() {
	echo "👍 $1"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/         Packages Management         /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function update_package_lists() {
	echo "🔄 Updating package lists 🔄"
	if ! apt-get -q update 2>&1; then
		handle_error "Failed to update package lists"
	fi

	announce_success "Package lists updated successfully."
}

# Function to upgrade packages if updates are available
# Usage: upgrade_packages
function upgrade_packages() {
	echo "⬆️ Upgrading packages ⬆️"

	# Check if there are packages to upgrade
	if ! apt-get -q -s upgrade 2>&1 | grep -q '^[[:digit:]]\+ upgraded'; then
		announce_no_job "No packages to upgrade."
		return
	fi

	# Actually perform the upgrade
	if ! apt-get -qy upgrade 2>&1; then
		handle_error "Failed to upgrade packages"
	fi

	announce_success "Packages successfully upgraded."
}

# Function to install packages with error handling
# Usage: install_packages "$@"
function install_packages() {
	echo "🔄 Installing Packages 🔄"
	for package in "${package_list[@]}"; do
		if ! apt-get -qy install "$package"; then
			handle_error "Failed to install packages"
		fi
	done

	announce_success "Packages installed successfully!"
}

# Function to update package lists the install packages with error handling
# invokes update_package_lists & install_packages in a single call
# Usage: update_and_install_packages $package_list
function update_and_install_packages() {
	update_package_lists
	install_packages $argv
}

# Function to remove unnecessary packages
function remove_unnecessary_packages() {
	echo "🧹 Removing unnecessary packages 🧹"

	# Check if there are packages to remove
	if ! apt-get autoremove --dry-run | grep -q '^[[:digit:]]\+ packages will be removed'; then
		announce_no_job "No unnecessary packages to remove."
		return
	fi

	# Actually remove them
	if ! apt-get -qy autoremove; then
		handle_error "Failed to remove unnecessary packages"
	fi

	announce_success "Unnecessary packages removed."
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

