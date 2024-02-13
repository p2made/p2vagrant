#!/bin/fish

# 06 Install Apache (with SSL & Markdown)

set script_name     "install_apache.fish"
set updated_date    "2024-02-13"

set active_title    "Installing Apache (with SSL 🔐 & Markdown 📄 🎊)"
set job_complete    "Apache Installed (with SSL 🔐 & Markdown 📄 🎊)"

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


set MARKDOWN_PACKAGES \
	libcgi-pm-perl \
	libcgi-fast-perl \
	markdown

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to install Apache
# Usage: install_apache
function install_apache
	# Add repository for ondrej/apache2
	LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

	# Update package lists & install packages
	update_and_install_packages $PACKAGE_LIST

	announce_success "Apache packages installed successfully!"

	# Install Markdown rendering packages
	update_and_install_packages $MARKDOWN_PACKAGES

	announce_success "Markdown rendering packages installed successfully!"
end

# Function to configure the default website
# Usage: configure_default_website
function configure_default_website
	# We have the data all as we want it, but in a global variable
	# Put it in local variables, & erase the global variable
	set domain            $VM_HOSTNAME
	set underscore_domain "html"
	set template_filename "0.conf"
	set vhosts_filename   "local.conf"
	set ssl_base_filename "$domain"_"$TODAYS_DATE"

	# Now go configure some web sites
	write_vhosts_file \
		$domain \
		$underscore_domain \
		$template_filename \
		$vhosts_filename \
		$ssl_base_filename
	generate_ssl_files \
		$domain \
		$ssl_base_filename
	configure_website \
		$domain \
		$underscore_domain \
		$vhosts_filename \
		$ssl_base_filename

	# Check if index.html exists in the html folder
	if not test -e $SHARED_HTML/index.html
		cp $PROVISION_HTML/index.html $SHARED_HTML/
	end

	# Set permissions on web server files
	chmod -R 755 $SHARED_HTML/*

	# Add configuration for handling Markdown files
	echo "AddType text/html .md" >> /etc/apache2/apache2.conf

	# Add handler for .md files
	echo "AddHandler cgi-script .md" >> /etc/apache2/conf-available/markdown.conf
	a2enconf markdown

	# Enable the new site
	a2ensite local.conf

	# Disable the default site
	a2dissite 000-default

	# Enable required Apache modules
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
