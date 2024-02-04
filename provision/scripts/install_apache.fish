#!/bin/fish

# 04 Install Apache (with SSL)
# Updated: 2024-02-04

set script_name     "install_apache.fish"
set updated_date    "2024-02-02"

set active_title    "Installing Apache (with SSL 🙃)"
set job_complete    "Apache Installed (with SSL 🙃)"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# NONE!"

# Script variables...

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

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

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
