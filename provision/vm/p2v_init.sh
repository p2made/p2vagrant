#!/bin/zsh

# provision/vm/p2v_init.sh

# Script to install packages for Vagrant and ./vm app

# Usage:
# `./provision/vm/p2v_init.sh "$(pwd)"`

# Common functions
source ./provision/vm/p2v_common.sh

# Function to install Homebrew
# Usage: install_homebrew
function install_homebrew() {
	if ! command -v brew &> /dev/null; then
		echo "Homebrew not found. Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		echo "Homebrew is already installed."
	fi
}

# Function to install Vagrant packages
# Usage: install_vagrant_packages
function install_vagrant_packages() {
	echo "Installing Vagrant packages..."

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

# Function to initialise p2v
# Usage: initialise_p2v
function initialise_p2v() {
	cat ./txt/application_init.txt

	# Prompt user to press any key to continue
	read -n 1 -s -r -p "Press any key to continue..."
	echo # Add a newline for better formatting

	install_homebrew
	install_vagrant_packages
	install_plugins "vagrant-share" "vagrant-vmware-desktop"
	install_extras "yq" "zenity"

	# Optional GUI app - Vagrant Manager
	install_vagrant_manager

	cp "./provision/txt/p2v_prefs" "./provision/data/p2v_prefs.yaml"

	echo "Installation of packages necessary for Vagrant and ./vm app complete."

	vagrant global-status
}

initialise_p2v

# debug_message "$LINENO" "Message"
