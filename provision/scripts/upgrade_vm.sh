#!/bin/bash

# 02 Upgrade VM

script_name="upgrade_vm.sh"
updated_date="2024-02-14"

active_title="Upgrading VM"
job_complete="Upgrade completed successfully"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh

# Arguments...
# NONE!

# Script variables...
# NONE!

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Header banner
upgrade_banner "$active_title" "$script_name" "$updated_date"

export DEBIAN_FRONTEND=noninteractive

update_package_lists
upgrade_packages
remove_unnecessary_packages

# Display OS information
echo "📄 Displaying OS information 📄"
cat /etc/os-release

# Footer banner
footer_banner "$job_complete"
