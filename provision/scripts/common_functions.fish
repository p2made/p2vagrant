#!/bin/fish

# common_functions.fish
# Last Updated: 2024-01-29

# Arguments...
# 1 - REMOTE_FOLDER   = "/var/www"

# Script variables...
set GENERATION_DATE     $(date "+%Y-%m-%d")

# Function to set path variables based on the passed path root
# Usage: set_path_variables /var/www - usually REMOTE_FOLDER from the Vagrantfile
# VM_FOLDER $argv[1]
# PROVISION_FOLDER $VM_FOLDER/provision
# DATA_FOLDER      $PROVISION_FOLDER/data
# HTML_FOLDER      $PROVISION_FOLDER/html
# LOGS_FOLDER      $PROVISION_FOLDER/logs
# SCRIPTS_FOLDER   $PROVISION_FOLDER/scripts
# SSL_FOLDER       $PROVISION_FOLDER/ssl
# TEMPLATES_FOLDER $PROVISION_FOLDER/templates
# VHOSTS_FOLDER    $PROVISION_FOLDER/vhosts
# WEB_FOLDER       $VM_FOLDER/html
function set_path_variables
	set -g VM_FOLDER $argv[1]
	set -g PROVISION_FOLDER $VM_FOLDER/provision
	set -g DATA_FOLDER      $PROVISION_FOLDER/data
	set -g HTML_FOLDER      $PROVISION_FOLDER/html
	set -g LOGS_FOLDER      $PROVISION_FOLDER/logs
	set -g SCRIPTS_FOLDER   $PROVISION_FOLDER/scripts
	set -g SSL_FOLDER       $PROVISION_FOLDER/ssl
	set -g TEMPLATES_FOLDER $PROVISION_FOLDER/templates
	set -g VHOSTS_FOLDER    $PROVISION_FOLDER/vhosts
	set -g WEB_FOLDER       $VM_FOLDER/html
end

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
