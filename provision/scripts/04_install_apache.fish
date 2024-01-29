#!/bin/fish

# 04 Install Apache (with SSL)

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing Apache (with SSL 🙃) 🚀"
echo "🇺🇿    📜 Script Name:  04_install_apache.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-29"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Variables...
# 1 - REMOTE_FOLDER   = "/var/www"
set VM_FOLDER           $1            # production version
#set VM_FOLDER           "/var/www"    # ssh test version
set PROVISION_FOLDER    $VM_FOLDER/provision
set HTML_FOLDER         $PROVISION_FOLDER/html
set SSL_FOLDER          $PROVISION_FOLDER/ssl
set VHOSTS_FOLDER       $PROVISION_FOLDER/vhosts
set WEB_FOLDER          "/var/www/html"

set PACKAGE_LIST \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

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

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Add repository for ondrej/apache2
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

announce_success "Apache packages installed successfully!"

# Generate SSL key
echo "🔄 Generating SSL key 🔄"
if not openssl genrsa \
	-out $SSL_FOLDER/localhost.key \
	2048
	handle_error "Failed to generate SSL key"
end

# Generate self-signed SSL certificate
echo "🔄 Generating self-signed SSL certificate 🔄"
if not openssl req -x509 -nodes \
	-key $SSL_FOLDER/localhost.key \
	-out $SSL_FOLDER/localhost.cert \
	-days 3650 \
	-subj "/CN=localhost" 2>/dev/null

	handle_error "Failed to generate self-signed SSL certificate"
end

announce_success "SSL files generated successfully!"

# Display information about the generated certificate
openssl x509 -noout -text -in $SSL_FOLDER/localhost.cert

# Copy web server files into place
yes | cp $VHOSTS_FOLDER/local.conf /etc/apache2/sites-available/
yes | cp $HTML_FOLDER/index.htm $WEB_FOLDER/
yes | cp $SSL_FOLDER/* /etc/apache2/sites-available/

# Check if index.html exists in the html folder
if not test -e $WEB_FOLDER/index.html
	# Copy index.html from the same source as index.htm
	cp $HTML_FOLDER/index.html $WEB_FOLDER/
end

# Set permissions on web server files
chmod -R 755 $WEB_FOLDER/*
chmod 600 /etc/apache2/sites-available/localhost.key

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

# Restart Apache to apply changes
systemctl restart apache2

announce_success "Apache Installed Successfully! ✅"

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 Apache Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
