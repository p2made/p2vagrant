#!/bin/sh

# 03 Install Utilities

# Variables...
# 1 - TIMEZONE   = "Australia/Brisbane"

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿 🚀 Installing Utilities 🚀"
echo "🇺🇿 📜 Script Name:  03_install_utilities.sh"
echo "🇹🇲 📅 Last Updated: 2024-01-26"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Function for error handling
handle_error() {
	echo "⚠️ Error: $1 💥"
	exit 1
}

export DEBIAN_FRONTEND=noninteractive

# Function to install packages with error handling
install_packages() {
	if ! apt-get -qy install "$@"; then
		handle_error "Failed to install packages"
	fi
}

# Function to update package lists
echo "🔄 Updating package lists 🔄"
if ! apt-get -q update; then
	handle_error "Failed to update package lists"
fi

# Set timezone
echo "🕤 Setting timezone to $1 🕓"
timedatectl set-timezone $1 --no-ask-password

# Add Fish Shell repository
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:fish-shell/release-3

# Call the function with the packages you want to install
install_packages \
	apt-transport-https \
	bzip2 \
	ca-certificates \
	curl \
	debconf-utils \
	expect \
	file \
	fish \
	git \
	gnupg2 \
	gzip \
	libapr1 \
	libaprutil1 \
	libaprutil1-dbd-sqlite3 \
	libaprutil1-ldap \
	liblua5.3-0 \
	lsb-release \
	mime-support \
	nodejs \
	npm \
	openssl \
	software-properties-common \
	unzip \
	yarn

echo "✅ Utilities Installation: Packages installed successfully!"

# Set Fish as the default shell
sudo usermod -s /usr/bin/fish vagrant
sudo chsh -s /usr/bin/fish vagrant

# Check if changing the default shell was successful
if [ $? -eq 0 ]; then
	echo "🐟 Default shell set to Fish shell https://fishshell.com 🐠"
else
	handle_error "Failed to set Fish shell as default"
fi

# Append the 'cd /var/www' line to .profile if it doesn't exist
grep -qxF 'cd /var/www' /home/vagrant/.profile || \
	echo 'cd /var/www' >> /home/vagrant/.profile

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿 🏆 Utilities Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
