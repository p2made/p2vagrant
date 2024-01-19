#!/bin/sh

# 05 Install Apache

# Variables...
# NONE!"

echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🚀 Installing Apache 🚀"
echo "Script Name:  install_apache.sh"
echo "Last Updated: 2024-01-20"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Add repository for ondrej/apache2
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

# Function to install packages with error handling
install_packages() {
	if ! apt-get -qy install "$@"; then
		echo "⚠️ Error: Failed to install packages 💥"
		exit 1
	fi
}

# Function to copy files into place & set permissions
copy_files() {
	yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
	yes | cp /var/www/provision/html/index.htm /var/www/html/
	yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

	sudo chmod -R 755 /var/www/html/*
}

# Function to enable site, disable site, and enable modules with error handling
enable_disable_modules_sites() {
	if ! a2ensite "$1" && ! a2dissite "$2" && ! a2enmod "$3" && ! a2enmod ssl; then
		echo "⚠️ Error: Failed to configure Apache sites and modules 💥"
		exit 1
	fi
}

# Call the function with the packages you want to install
install_packages \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

echo ""
echo "✅ Apache Installation: Packages installed successfully!"
echo ""

# Call the function to copy files
copy_files

# Call the function to enable/disable sites and enable modules (including ssl)
enable_disable_modules_sites local.conf 000-default rewrite

service apache2 restart

echo ""
echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🏆 Apache Installed ‼️"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
