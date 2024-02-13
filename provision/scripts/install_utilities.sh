#!/bin/bash

# 03 Install Utilities

script_name="install_utilities.sh"
updated_date="2024-02-12"

active_title="Installing Utilities"
job_complete="Utilities Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.sh

# Arguments...
TIMEZONE=$1         # "Australia/Brisbane"

# Script variables...

# Always set PACKAGE_LIST when using update_and_install_packages
PACKAGE_LIST=(
	"apt-transport-https"
	"bzip2"
	"ca-certificates"
	"curl"
	"debconf-utils"
	"expect"
	"file"
	"fish"
	"git"
	"gnupg2"
	"gzip"
	"libapr1"
	"libaprutil1"
	"libaprutil1-dbd-sqlite3"
	"libaprutil1-ldap"
	"liblua5.3-0"
	"lsb-release"
	"mime-support"
	"nodejs"
	"npm"
	"openssl"
	"software-properties-common"
	"unzip"
	"yarn"
)

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to set Fish as the default shell
function set_fish_as_default_shell () {
	if ! sudo usermod -s /usr/bin/fish vagrant; then
		handle_error "Failed to set Fish shell as default"
	fi

	sudo chsh -s /usr/bin/fish vagrant

	echo "🐟 Default shell set to Fish shell https://fishshell.com 🐠"
}

function advance_vm () {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	export DEBIAN_FRONTEND=noninteractive

	# Set timezone
	echo "🕤 Setting timezone to $TIMEZONE 🕓"
	timedatectl set-timezone "$TIMEZONE" --no-ask-password

	# Add Fish Shell repository
	LC_ALL=C.UTF-8 apt-add-repository -yu ppa:fish-shell/release-3

	install_packages $PACKAGE_LIST

	set_fish_as_default_shell # Let's swim 🐟🐠🐟🐠🐟🐠

	# Append the 'cd /var/www' line to .profile if it doesn't exist
	grep -qxF 'cd /var/www' /home/vagrant/.profile || \
		echo 'cd /var/www' >> /home/vagrant/.profile

	# Display Time Zone information
	echo "📄 Displaying Time Zone information 📄"
	timedatectl

	# Footer banner
	footer_banner "$job_complete"
}

advance_vm
