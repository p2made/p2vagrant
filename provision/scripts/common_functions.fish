#!/bin/fish

# common_functions.fish
# Last Updated: 2024-01-29

# Script variables...
# GENERATION_DATE     $(date "+%Y-%m-%d")
# VM_FOLDER           /var/www
# WEB_FOLDER          $VM_FOLDER/html
# PROVISION_FOLDER    $VM_FOLDER/provision
# PROVISION_DATA      $VM_FOLDER/provision/data
# PROVISION_HTML      $VM_FOLDER/provision/html
# PROVISION_LOGS      $VM_FOLDER/provision/logs
# PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
# PROVISION_SSL       $VM_FOLDER/provision/ssl
# PROVISION_TEMPLATES $VM_FOLDER/provision/templates
# PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

set -gx GENERATION_DATE     $(date "+%Y-%m-%d")
set -gx VM_FOLDER           /var/www
set -gx WEB_FOLDER          $VM_FOLDER/html
set -gx PROVISION_FOLDER    $VM_FOLDER/provision
set -gx PROVISION_DATA      $VM_FOLDER/provision/data
set -gx PROVISION_HTML      $VM_FOLDER/provision/html
set -gx PROVISION_LOGS      $VM_FOLDER/provision/logs
set -gx PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
set -gx PROVISION_SSL       $VM_FOLDER/provision/ssl
set -gx PROVISION_TEMPLATES $VM_FOLDER/provision/templates
set -gx PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

# Function for error handling
# Usage: handle_error "Error message"
function handle_error
	echo "⚠️ Error: $argv 💥"
	exit 1
end

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success
	set icon "✅"

	if test -n "$argv[2]"
		if test "$argv[2]" -eq 1
			set icon "👍"
		end
	end

	echo "$icon $argv[1]"
end

function update_package_lists
	echo "🔄 Updating package lists 🔄"

	if not apt-get -q update > /dev/null 2>&1
		handle_error "Failed to update package lists"
	end

	announce_success "Package lists updated successfully."
end

function install_packages
	echo "🔄 Installing Packages 🔄"

	for package in $argv
		set cleaned (eval echo $package)
		if not apt-get -qy install $cleaned
			handle_error "Failed to install packages"
		end
	end

	announce_success "Packages installed successfully!"
end

# Function to update package lists the install packages with error handling
# Usage: install_packages $package_list
function update_and_install_packages
	update_package_lists
	install_packages $argv
end
