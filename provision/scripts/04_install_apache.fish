#!/bin/fish

# 04 Install Apache (with SSL)

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing Apache (with SSL 🙃) 🚀"
echo "🇺🇿    📜 Script Name:  04_install_apache.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-28"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Variables...
# NONE!"

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

# Function to install packages with error handling
# Usage: install_packages $package_list

set -x DEBIAN_FRONTEND noninteractive

# Add repository for ondrej/apache2
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2


# Update package lists
update_package_lists

# Install PHP packages
install_packages $PACKAGE_LIST

announce_success "Apache packages installed successfully!"

# Generate SSL key
echo "🔄 Generating SSL key 🔄"
if not openssl genrsa \
	-out /var/www/provision/ssl/localhost.key \
	2048
	handle_error "Failed to generate SSL key"
end

# Generate self-signed SSL certificate
# Generate self-signed SSL certificate
echo "🔄 Generating self-signed SSL certificate 🔄"
if not openssl req -x509 -nodes \
	-keyout /var/www/provision/ssl/localhost.key \
	-out /var/www/provision/ssl/localhost.cert \
	-days 3650 \
	-subj "/CN=\\*.localhost" 2>/dev/null

	handle_error "Failed to generate self-signed SSL certificate"
end

announce_success "SSL files generated successfully!"

# Display information about the generated certificate
openssl x509 -noout -text -in /var/www/provision/ssl/localhost.cert

# Copy web server files into place
yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/html/index.htm /var/www/html/
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

# Set permissions on web server files
sudo chmod -R 755 /var/www/html/*
sudo chmod 600 /etc/apache2/sites-available/localhost.key

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

service apache2 restart

announce_success "Apache Installed Successfully! ✅"

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 Apache Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
