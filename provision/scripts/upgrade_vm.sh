#!/bin/bash

# 02 Upgrade VM

script_name="upgrade_vm.sh"
updated_date="2024-02-12"

active_title="Upgrading VM"
job_complete="Upgrade completed successfully"

# Source common functions
source /var/www/provision/scripts/common_functions.sh

# Arguments...
TIMEZONE=$1         # "Australia/Brisbane"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function advance_vm () {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	export DEBIAN_FRONTEND=noninteractive

	# Set timezone
	echo "🕤 Setting timezone to $1 🕓"
	timedatectl set-timezone "$TIMEZONE" --no-ask-password

	update_package_lists
	upgrade_packages
	remove_unnecessary_packages

	# Display OS information
	echo "📄 Displaying OS information 📄"
	cat /etc/os-release

	announce_success "System update complete! ✅"

	# Footer banner
	footer_banner "$job_complete"
}

advance_vm
