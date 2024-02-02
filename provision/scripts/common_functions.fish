#!/bin/fish

# common_functions.fish
# Last Updated: 2024-02-01

# Script constants...

# TODAYS_DATE         $(date "+%Y-%m-%d")
# VM_FOLDER           /var/www
# SHARED_HTML         $VM_FOLDER/html
# PROVISION_FOLDER    $VM_FOLDER/provision
# PROVISION_DATA      $VM_FOLDER/provision/data
# PROVISION_HTML      $VM_FOLDER/provision/html
# PROVISION_LOGS      $VM_FOLDER/provision/logs
# PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
# PROVISION_SSL       $VM_FOLDER/provision/ssl
# PROVISION_TEMPLATES $VM_FOLDER/provision/templates
# PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

set -g TODAYS_DATE         (date "+%Y-%m-%d")
set -g VM_FOLDER           /var/www
set -g SHARED_HTML         $VM_FOLDER/html
set -g PROVISION_FOLDER    $VM_FOLDER/provision
set -g PROVISION_DATA      $VM_FOLDER/provision/data
set -g PROVISION_HTML      $VM_FOLDER/provision/html
set -g PROVISION_LOGS      $VM_FOLDER/provision/logs
set -g PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
set -g PROVISION_SSL       $VM_FOLDER/provision/ssl
set -g PROVISION_TEMPLATES $VM_FOLDER/provision/templates
set -g PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

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

# Function to update package with error handling
# Usage: update_package_lists
function update_package_lists
	echo "🔄 Updating package lists 🔄"

	if not apt-get -q update > /dev/null 2>&1
		handle_error "Failed to update package lists"
	end

	announce_success "Package lists updated successfully."
end

# Function to install packages with error handling
# Usage: install_packages $package_list
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
# invokes update_package_lists & install_packages in a single call
# Usage: update_and_install_packages $package_list
function update_and_install_packages
	update_package_lists
	install_packages $argv
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function header_banner
	echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
	echo "🇺🇦"
	echo "🇺🇦    🚀 $argv[1] 🚀"
	echo "🇺🇦        on 📅 $TODAYS_DATE 📅"
	echo "🇺🇦"
	echo "🇺🇦    📜 Script Name:  $argv[2]"
	echo "🇺🇦    📅 Last Updated: $argv[3]"
	echo "🇺🇦"
	echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳"
	echo ""
end

function footer_banner
	echo ""
	echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
	echo "🇺🇦"
	echo "🇺🇦    🏆 $argv[1] ‼️"
	echo "🇺🇦"
	echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳"
end
