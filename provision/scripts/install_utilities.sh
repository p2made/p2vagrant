#!/bin/sh

# 03 Install Utilities

# Variables...
# $1 - TIMEZONE     = "Australia/Brisbane"

echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🚀 Installing Utilities 🚀"
echo "Script Name: $0"
echo "Last Updated: 2023-01-19"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Function to install packages with error handling
install_packages() {
	packages=("$@")
	if ! apt-get -qy install "${packages[@]}"; then
	    echo "⚠️ Error: Failed to install packages 💥"
	    exit 1
	fi
}

# Update package lists
apt-get update

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

echo "✅ Utilities Installation: Packages installed successfully!"

chsh -s /usr/bin/fish
grep -qxF 'cd /var/www' /home/vagrant/.profile || echo 'cd /var/www' >> /home/vagrant/.profile

echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🏆 Utilities Installed ‼️"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
