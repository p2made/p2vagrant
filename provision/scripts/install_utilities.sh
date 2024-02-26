#!/bin/bash

# 03 Install Utilities

script_name="install_utilities.sh"
updated_date="2024-02-15"

active_title="Installing Utilities"
job_complete="Utilities Installed"

# Source common functions
source /var/www/provision/scripts/_common.sh

# Arguments...
VM_HOSTNAME=$1      # "p2vagrant"
TIMEZONE=$2         # "Australia/Brisbane"

# Script variables...

# Always set package_list when using...
# install_packages() or update_and_install_packages()
package_list=(
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

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to set Fish as the default shell
function set_fish_as_default_shell() {
	if ! sudo usermod -s /usr/bin/fish vagrant; then
		handle_error "Failed to set Fish shell as default"
	fi

	sudo chsh -s /usr/bin/fish vagrant

	echo "🐟 Default shell set to Fish shell https://fishshell.com 🐠"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function provision() {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date" false

	export DEBIAN_FRONTEND=noninteractive

	# Set timezone
	echo "🕤  Setting timezone to $TIMEZONE 🕓"
	sudo timedatectl set-timezone "$TIMEZONE"

	# Set the hostname using hostnamectl
	echo "⚙️  Setting hostname to $VM_HOSTNAME ⚙️"
	sudo hostnamectl set-hostname "$VM_HOSTNAME"

	# Update /etc/hosts to include the new hostname
	sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$VM_HOSTNAME/" /etc/hosts

	# Add Fish Shell repository
	LC_ALL=C.UTF-8 add-apt-repository -yu ppa:fish-shell/release-3

	update_package_lists
	install_packages $package_list

	set_fish_as_default_shell # Let's swim 🐟🐠🐟🐠🐟🐠

	# Append the 'cd /var/www' line to .profile if it doesn't exist
	grep -qxF 'cd /var/www' /home/vagrant/.profile || \
		echo 'cd /var/www' >> /home/vagrant/.profile

	# Display Time Zone information
	echo "🕤  Displaying Time Zone information 🕤"
	timedatectl

	# Display hostname information
	echo "⚙️  Displaying Time Zone information ⚙️"
	hostnamectl

	# Footer banner
	footer_reboot "$job_complete"
}

provision

# Reboot the system
sudo reboot
