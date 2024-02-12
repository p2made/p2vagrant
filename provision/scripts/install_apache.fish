#!/bin/fish

# 05 Install Apache (with SSL)

set script_name     "install_apache.fish"
set updated_date    "2024-02-12"

set active_title    "Installing Apache (with SSL 🙃)"
set job_complete    "Apache Installed (with SSL 🙃)"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# Arguments...
set VM_HOSTNAME     $argv[1]
set VM_IP           $argv[2]

# Script variables...
# NONE!

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to install Apache
# Usage: install_apache
function install_apache
	# Add repository for ondrej/apache2
	LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

	# Update package lists & install packages
	update_and_install_packages $PACKAGE_LIST

	announce_success "Apache packages installed successfully!"
end

# Function to configure the default website
# Usage: configure_default_website
function configure_default_website
	# We have the data all as we want it, but in a global variable
	# Put it in local variables, & erase the global variable
	set domain            $VM_HOSTNAME
	set template_filename "0.conf"
	set vhosts_filename   "local.conf"
	set ssl_base_filename "$domain"_"$TODAYS_DATE"

	# Now go configure some web sites
	write_vhosts_file \
		$domain \
		$domain \
		$template_filename \
		$vhosts_filename \
		$ssl_base_filename
	generate_ssl_files \
		$domain \
		$ssl_base_filename
	configure_website \
		$domain \
		$domain \
		$vhosts_filename \
		$ssl_base_filename

	# Copy web server files into place
	yes | cp $PROVISION_VHOSTS/$vhosts_filename /etc/apache2/sites-available/
	yes | cp $PROVISION_SSL/* /etc/apache2/sites-available/
	yes | cp $PROVISION_HTML/index.htm $SHARED_HTML/

	# Check if index.html exists in the html folder
	if not test -e $SHARED_HTML/index.html
		cp $PROVISION_HTML/index.html $SHARED_HTML/
	end

	# Set permissions on web server files
	chmod -R 755 $SHARED_HTML/*
	chmod 600 /etc/apache2/sites-available/$ssl_base_filename.key

	a2ensite local.conf
	a2dissite 000-default
	a2enmod rewrite
	a2enmod ssl
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function advance_vm
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	set -x DEBIAN_FRONTEND noninteractive

	install_apache
	configure_default_website

	# Restart Apache to apply changes
	systemctl restart apache2

	# Footer banner
	footer_banner "$job_complete"
end

advance_vm
