#!/bin/sh

# 10 Install Yarn

# Variables...
# NONE!"

# Function for error handling
handle_error() {
	echo "⚠️ Error: $1 💥"
	exit 1
}

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🚀 Installing Yarn 🚀"
echo "Script Name:  install_yarn.sh"
echo "Last Updated: 2024-01-21"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Call the vm_upgrade.sh script
/var/www/provision/scripts/vm_upgrade.sh

echo "🔑 Adding Yarn GPG key..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - || \
	handle_error "Failed to add Yarn GPG key."

echo "📦 Adding Yarn repository..."
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

echo "🔄 Updating package lists after adding Yarn repository..."
apt-get update || \
	handle_error "Failed to update package lists after adding Yarn repository."

echo "🚀 Installing Yarn..."
apt-get -qy install yarn || \
	handle_error "Failed to install Yarn."

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 Yarn Installed ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
