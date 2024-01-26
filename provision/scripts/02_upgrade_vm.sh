#!/bin/bash

# 02 Upgrade VM

# Variables...
# NONE!"

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Upgrading VM 🚀"
echo "🇺🇿    📜 Script Name:  02_upgrade_vm.sh"
echo "🇹🇲    📅 Last Updated: 2024-01-26"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Function for error handling
handle_error() {
	echo "⚠️ Error: $1 💥"
	exit 1
}

export DEBIAN_FRONTEND=noninteractive

# Function to update package lists
echo "🔄 Updating package lists 🔄"
if ! apt-get -q update 2>&1; then
	handle_error "Failed to update package lists"
fi

# Function to upgrade packages if updates are available
if apt-get -q -s upgrade 2>&1 | grep -q '^[[:digit:]]\+ upgraded'; then
	echo "⬆️ Upgrading packages ⬆️"
	if ! apt-get -qy upgrade 2>&1; then
		handle_error "Failed to upgrade packages"
	fi
else
	echo "👍 No packages to upgrade."
fi

# Function to remove unnecessary packages
echo "🧹 Removing unnecessary packages 🧹"
if apt-get autoremove --dry-run | grep -q '^[[:digit:]]\+ packages will be removed'; then
	if ! apt-get -qy autoremove; then
		handle_error "Failed to remove unnecessary packages"
	fi
else
	echo "👍 No unnecessary packages to remove."
fi

# Display OS information
echo "📄 Displaying OS information 📄"
cat /etc/os-release
echo "✅ System update complete! ✅"

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 Upgrade completed successfully ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
