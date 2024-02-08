#!/bin/bash

# 02 Upgrade VM

script_name="upgrade_vm.sh"
updated_date="2024-02-08"

active_title="Upgrading VM"
job_complete="Upgrade completed successfully"

# Source common functions
source /var/www/provision/scripts/common_functions.sh

header_banner "$active_title" "$script_name" "$updated_date"
# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
TIMEZONE=$1         # "Australia/Brisbane"

export DEBIAN_FRONTEND=noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Set timezone
echo "🕤 Setting timezone to $1 🕓"
timedatectl set-timezone $1 --no-ask-password

update_package_lists
upgrade_packages
remove_unnecessary_packages

# Display OS information
echo "📄 Displaying OS information 📄"
cat /etc/os-release

announce_success "System update complete! ✅"

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner "$job_complete"
