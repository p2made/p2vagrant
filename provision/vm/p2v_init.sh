#!/bin/zsh

# provision/vm/p2v_init.sh

# Script to install packages for Vagrant and ./vm app

# Usage:
# `./provision/vm/p2v_init.sh`

# Common functions
source ./provision/vm/p2v_common.sh

# Function to check that homebrew is installed
# Usage: check_homebrew
function check_homebrew() {
	if ! command -v brew &> /dev/null; then
		echo "Homebrew is not installed. Please install Homebrew before running this script."
		exit 1
	fi
}

# Function to install Vagrant packages
# Usage: install_vagrant_packages
function install_vagrant_packages() {
	echo "Installing necessary packages..."

	# Check if Vagrant is already installed
	if ! command -v vagrant &> /dev/null; then
		brew install --cask vagrant
	else
		echo "Vagrant is already installed."
	fi

	# Check if Vagrant VMware Utility is already installed
	if ! brew list --cask | grep -q 'vagrant-vmware-utility'; then
		brew install --cask vagrant-vmware-utility
	else
		echo "Vagrant VMware Utility is already installed."
	fi
}

# Function to install Vagrant plugins
# Usage: install_plugins "plugin1" "plugin2" ...
function install_plugins() {
	for plugin in "$@"; do
		vagrant plugin list | grep -q "$plugin" || \
			vagrant plugin install "$plugin"
	done
}

# Function to install additional packages
# Usage: install_extras "package1" "package2" ...
function install_extras() {
	for package in "$@"; do
		# Check if the package is already installed
		if ! command -v "$package" &> /dev/null; then
			brew install "$package"
		else
			echo "$package is already installed."
		fi
	done
}

# Function to optionally install Vagrant Manager desktop application
# Usage: install_vagrant_manager
function install_vagrant_manager() {
	local message="Do you want to install Vagrant Manager desktop application?"
	if ! ask_yes_no "$message"; then
		echo "Skipping the installation of Vagrant Manager."
	fi

	brew install --cask vagrant-manager
}

# Main function to coordinate the installation process
# Usage: initialize_p2v
function initialize_p2v() {
	# Check if Homebrew is installed
	check_homebrew

	#read -qs "?$message_1: " answer
	#echo  # Add a newline for better formatting

	# Install Vagrant packages
	install_vagrant_packages

	# Install Vagrant plugins
	install_plugins "vagrant-share" "vagrant-vmware-desktop"

	# Install yq and zenity
	install_extras "yq" "zenity"

	# Optional GUI app - Vagrant Manager
	install_vagrant_manager

	echo "Installation of packages necessary for Vagrant and ./vm app complete."

	vagrant global-status
}

initialize_p2v

# debug_message "$LINENO" "Message"
