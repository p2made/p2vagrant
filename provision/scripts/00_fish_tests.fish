#!/bin/fish

# 00 fish_tests

set active_title    "Fish Tests"
set script_name     "00_fish_tests.fish"
set updated_date    "2024-02-02"
set job_complete    "Tests Complete"

# Source common functions
source /var/www/provision/scripts/common.fish
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - TIMEZONE   = "Australia/Brisbane"
# NONE!"

# Script constants...

# GENERATION_DATE     $(date "+%Y-%m-%d")
# VM_FOLDER           /var/www
# SHARED_HTML          $VM_FOLDER/html
# PROVISION_FOLDER    $VM_FOLDER/provision
# PROVISION_DATA      $VM_FOLDER/provision/data
# PROVISION_HTML      $VM_FOLDER/provision/html
# PROVISION_LOGS      $VM_FOLDER/provision/logs
# PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
# PROVISION_SSL       $VM_FOLDER/provision/ssl
# PROVISION_TEMPLATES $VM_FOLDER/provision/templates
# PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

# Script variables...

# Always set PACKAGE_LIST when using update_and_install_packages
#set PACKAGE_LIST \


set -x DEBIAN_FRONTEND noninteractive


echo $LOGS_FOLDER_EXISTS

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
