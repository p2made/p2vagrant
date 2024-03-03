#!/bin/zsh

# p2v_init.sh

# Script to install packages for Vagrant and ./p2v app

# Usage:
# `./provision/vm/p2v_init.sh "$(pwd)"`

# Common functions
source ./provision/vm/p2v_common.sh

# Change working directory to the 'vm' directory
cd "$1"

cat "./provision/vm/txt/art_flags.txt"
cat "./provision/vm/txt/art_ua.txt"
cat "./provision/vm/txt/art_p2v_init.txt"
cat "./provision/vm/txt/art_ua.txt"
cat "./provision/vm/txt/art_copyright.txt"
cat "./provision/vm/txt/art_ua.txt"
cat "./provision/vm/txt/art_flags.txt"
echo
cat ./provision/vm/txt/application_init.txt

message="Do you want to initialise p2v (password may be necessary)?"
echo
if ! ask_yes_no "$message"; then
	echo "p2v initialisation cancelled."
	exit 0
fi
echo

# Install Homebrew
if ! command -v brew &> /dev/null; then
	echo "Homebrew not found. Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew is already installed."
fi

# Install Vagrant packages
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

# Function to install Vagrant plugins
plugins=("vagrant-share" "vagrant-vmware-desktop")
for plugin in "${plugins[@]}"; do
	vagrant plugin list | grep -q "$plugin" || vagrant plugin install "$plugin"
done

extras=("yq" "zenity")
for package in "${extras[@]}"; do
	# Check if the package is already installed
	if ! command -v "$package" &> /dev/null; then
		brew install "$package"
	else
		echo "$package is already installed."
	fi
done

echo
if ask_yes_no "$message"; then
	brew install --cask vagrant-manager
else
	echo "Skipping the installation of Vagrant Manager."
fi
echo

# Check if Vagrant Manager is NOT installed
if ! brew list --cask | grep -q 'vagrant-manager'; then
	# Optional GUI app - Vagrant Manager
	echo
	echo "Vagrant Manager is a small desktop application that you may find useful."
	message="Do you want to install Vagrant Manager?"
	if ask_yes_no "$message"; then
		brew install --cask vagrant-manager
	else
		echo "Skipping the installation of Vagrant Manager."
	fi
	echo
fi

# Copy p2v_prefs template to the prefs file location
cp "./provision/vm/txt/p2v_prefs" "$P2V_PREFS" || \
	handle_error "Failed to create prefs file"

vagrant global-status

p2v_prefs



announce_success "Installation of packages necessary for Vagrant and p2v app complete."
