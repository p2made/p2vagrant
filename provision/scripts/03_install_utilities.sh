#!/bin/bash

# 03 Install Utilities

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing Utilities 🚀"
echo "🇺🇿    📜 Script Name:  03_install_utilities.sh"
echo "🇹🇲    📅 Last Updated: 2024-01-27"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Variables...
# 1 - TIMEZONE   = "Australia/Brisbane"

# Function for error handling
# Usage: handle_error "Error message"
handle_error() {
	echo "⚠️ Error: $1 💥"
	echo "Run `vagrant halt` then restore the last snapshot before trying again."
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully."
announce_success() {
	echo "✅ $1"
}

export DEBIAN_FRONTEND=noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to install packages with progress dots and error handling
install_packages() {
	echo "🔄 Installing packages 🔄"

	# Run apt-get in a subshell to capture its output
	(
		while IFS= read -r line; do
			echo -n "🐌"
		done < <(apt-get -qy install "$@" 2>&1)
		echo ""  # Move to the next line after the dots
	)

	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
		handle_error "Failed to install packages"
	fi

	announce_success "Utilities Installation: Packages installed successfully!"
}

update_package_lists() {
	echo "🔄 Updating package lists 🔄"
	if ! apt-get -q update 2>&1; then
		handle_error "Failed to update package lists"
	fi
}

# Function to set Fish as the default shell
set_fish_as_default_shell() {
	if ! sudo usermod -s /usr/bin/fish vagrant; then
		handle_error "Failed to set Fish shell as default"
	fi

	sudo chsh -s /usr/bin/fish vagrant

	echo "🐟 Default shell set to Fish shell https://fishshell.com 🐠"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

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

set_fish_as_default_shell

# Append the 'cd /var/www' line to .profile if it doesn't exist
grep -qxF 'cd /var/www' /home/vagrant/.profile || \
	echo 'cd /var/www' >> /home/vagrant/.profile

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 Utilities Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
