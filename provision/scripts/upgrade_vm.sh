#!/bin/sh

# 02 Upgrade VM

# Variables...
# NONE!"

echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🚀 Upgrading VM 🚀"
echo "Script Name:  upgrade_vm.sh"
echo "Last Updated: 2023-01-19"
echo "Should always run first "
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭
echo ""

export DEBIAN_FRONTEND=noninteractive

# Function for error handling
handle_error() {
	echo "⚠️ Error: $1 💥"
	exit 1
}

# Function to update package lists
echo "🔄 Updating package lists 🔄"
if ! apt-get -q update; then
	handle_error "⚠️ Failed to update package lists"
fi

# Function to upgrade packages
echo "⬆️ Upgrading packages ⬆️"
if ! apt-get -qy upgrade; then
	handle_error "⚠️ Failed to upgrade packages"
fi

# Function to remove unnecessary packages
echo "🧹 Removing unnecessary packages 🧹"
if ! apt-get autoremove; then
	handle_error "⚠️ Failed to remove unnecessary packages"
fi

# Display OS information
echo "📄 Displaying OS information 📄"
cat /etc/os-release

echo ""
echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🏆 Upgrade completed successfully ‼️"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭
