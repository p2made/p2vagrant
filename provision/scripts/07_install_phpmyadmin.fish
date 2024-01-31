#!/bin/fish

# 07 Install phpMyAdmin

echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
echo "🇺🇦"
echo "🇺🇦    🚀 Installing phpMyAdmin 🚀"
echo "🇺🇦    📜 Script Name:  07_install_phpmyadmin.fish"
echo "🇺🇦    📅 Last Updated: 2024-01-28"
echo "🇺🇦"
echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳"
echo ""
# -- -- /%/ -- -- /%/ -- header_banner -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - REMOTE_FOLDER     = "/var/www"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# Function for error handling
# Usage: handle_error "Error message"

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]

# Function to update package lists
# Usage: update_package_lists

# Function to install packages with error handling
# Usage: install_packages $package_list

# Script variables...

# Function to set path variables based on the passed path root
# Usage: set_path_variables /var/www - usually REMOTE_FOLDER from the Vagrantfile
# VM_FOLDER $argv[1] - usually /var/www
# PROVISION_FOLDER $VM_FOLDER/provision
# PROVISION_DATA      $PROVISION_FOLDER/data
# PROVISION_HTML      $PROVISION_FOLDER/html
# PROVISION_LOGS      $PROVISION_FOLDER/logs
# PROVISION_SCRIPTS   $PROVISION_FOLDER/scripts
# PROVISION_SSL       $PROVISION_FOLDER/ssl
# PROVISION_TEMPLATES $PROVISION_FOLDER/templates
# PROVISION_VHOSTS    $PROVISION_FOLDER/vhosts
# SHARED_HTML       $VM_FOLDER/html
set_path_variables $argv[1]

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Add repository for phpMyAdmin
LC_ALL=C.UTF-8 sudo apt-add-repository -yu ppa:phpmyadmin/ppa
LC_ALL=C.UTF-8 sudo apt-add-repository --yes -u ppa:phpmyadmin/ppa

# Update package lists & install packages
update_package_lists

apt -qy install phpmyadmin

# Remove the default phpMyAdmin directory
rm -rf /usr/share/phpmyadmin

# Copy phpMyAdmin to the specified folder
rm -rf $SHARED_HTML/phpmyadmin && \
cp -R $PROVISION_HTML/phpmyadmin $SHARED_HTML/phpmyadmin

# Set permissions
chmod -R 755 $SHARED_HTML/phpmyadmin

# Enable mbstring
phpenmod mbstring

# -- -- /%/ -- -- /%/ -- footer_banner -- /%/ -- -- /%/ -- --
echo ""
echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
echo "🇺🇦"
echo "🇺🇦    🏆 phpMyAdmin Installed ‼️"
echo "🇺🇦"
echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳"
