#!/bin/sh

# 03 Install Utilities
# Updated 2024-01-26

# Variables...
# 1 - TIMEZONE   = "Australia/Brisbane"

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿 🚀 Installing Utilities 🚀"
echo "🇺🇿 📜 Script Name:  install_utilities.sh"
echo "🇹🇲 📅 Last Updated: 2024-01-26"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Function to install packages with error handling
install_packages() {
	if ! apt-get -qy install "$@"; then
		echo "⚠️ Error: Failed to install packages 💥"
		exit 1
	fi
}

# Function to update package lists
echo "🔄 Updating package lists 🔄"
if ! apt-get -q update; then
	handle_error "⚠️ Failed to update package lists"
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
	openssl \
	software-properties-common \
	unzip

echo ""
echo "✅ Utilities Installation: Packages installed successfully!"
echo ""

# Set Fish as the default shell
chsh -s /usr/bin/fish

# Check if changing the default shell was successful
if [ $? -eq 0 ]; then
	echo "🐟 Default shell set to Fish shell https://fishshell.com 🐠"
else
	echo "⚠️ Error: Failed to set Fish shell as default 💥"
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
