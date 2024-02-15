#!/bin/bash

# 05 Install Apache (with SSL & Markdown)

script_name="install_apache.sh"
updated_date="2024-02-15"

active_title="Installing Apache (with SSL 🔐 & Markdown 📄)"
job_complete="Apache Installed (with SSL 🔐 & Markdown 📄)"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh
source /var/www/provision/scripts/_sites.sh

# Arguments...
# NONE!

# Script variables...
# NONE!

# Always set package_list when using update_and_install_packages
package_list=(
	"apache2"
	"apache2-bin"
	"apache2-data"
	"apache2-utils"
)

markdown_packages=(
	"markdown"
	"pandoc"
)

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to install Apache
# Usage: install_apache
function install_apache() {
	# Add repository for ondrej/apache2
	LC_ALL=C.UTF-8 add-apt-repository -yu ppa:ondrej/apache2 ||
		handle_error "Failed to add Apache repository"

	# Update package lists & install packages
	update_package_lists
	install_packages $package_list

	# Enable required Apache modules
	a2enmod rewrite
	a2enmod ext_filter
	a2enmod ssl

	announce_success "Apache packages installed successfully!"

	install_packages $markdown_packages

	announce_success "Markdown rendering packages installed successfully!"
}

# Function to configure the default website
# Usage: configure_default_website
function configure_default_website() {
	# We have the data all as we want it, but in a global variable
	# Put it in local variables, & erase the global variable
	domain=$VM_HOSTNAME
	underscore_domain="html"
	template_filename="0.conf"
	vhosts_filename="local.conf"
	ssl_base_filename="$domain"_"$TODAYS_DATE"

	# Now go configure some web sites
	generate_vhosts_file \
		"$domain" \
		"$underscore_domain" \
		"$template_filename" \
		"$vhosts_filename" \
		"$ssl_base_filename"
	generate_ssl_files \
		"$domain" \
		"$ssl_base_filename"
	configure_website \
		"$domain" \
		"$underscore_domain" \
		"$vhosts_filename" \
		"$ssl_base_filename"

	# Disable the default site
	a2dissite 000-default
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function provision() {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	export DEBIAN_FRONTEND=noninteractive

	install_apache
	configure_default_website

	# Restart Apache to apply changes
	systemctl restart apache2

	# Footer banner
	footer_banner "$job_complete"
}

provision
