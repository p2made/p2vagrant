#!/bin/fish

# 04 Install Apache (with SSL)

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner \
	"Installing Apache (with SSL 🙃)" \
	"04_install_apache.fish" \
	"2024-02-02"

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --
set job_complete "Apache Installed (with SSL 🙃)"

# Arguments...
# NONE!"

# Script constants...

# TODAYS_DATE         $(date "+%Y-%m-%d")
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

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	install_apache2 \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

# Script functions...

# Function for error handling
# Usage: handle_error "Error message"

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]

# Function to update package with error handling
# Usage: update_package_lists

# Function to install packages with error handling
# Usage: install_packages $package_list

# Function to update package lists the install packages with error handling
# invokes update_package_lists & install_packages in a single call
# Usage: update_and_install_packages $package_list

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Add repository for ondrej/apache2
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

announce_success "Apache packages installed successfully!"

# Generate SSL key
echo "🔄 Generating SSL key 🔄"
if not openssl genrsa \
	-out $PROVISION_SSL/localhost.key \
	2048
	handle_error "Failed to generate SSL key"
end

# Generate self-signed SSL certificate
echo "🔄 Generating self-signed SSL certificate 🔄"
if not openssl req -x509 -nodes \
	-key $PROVISION_SSL/localhost.key \
	-out $PROVISION_SSL/localhost.cert \
	-days 3650 \
	-subj "/CN=localhost" 2>/dev/null

	handle_error "Failed to generate self-signed SSL certificate"
end

announce_success "SSL files generated successfully!"

# Display information about the generated certificate
openssl x509 -noout -text -in $PROVISION_SSL/localhost.cert

# Copy web server files into place
yes | cp $PROVISION_VHOSTS/local.conf /etc/apache2/sites-available/
yes | cp $PROVISION_SSL/* /etc/apache2/sites-available/
yes | cp $PROVISION_HTML/index.htm $SHARED_HTML/

# Check if index.html exists in the html folder
if not test -e $SHARED_HTML/index.html
	cp $PROVISION_HTML/index.html $SHARED_HTML/
end

# Set permissions on web server files
chmod -R 755 $SHARED_HTML/*
chmod 600 /etc/apache2/sites-available/localhost.key

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

# Restart Apache to apply changes
systemctl restart apache2

# -- -- /%/ -- -- /%/ -- footer_banner -- /%/ -- -- /%/ -- --
footer_banner $job_complete
