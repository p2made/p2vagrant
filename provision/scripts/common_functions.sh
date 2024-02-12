#!/bin/bash

# common_functions.sh
# Updated: 2024-02-08

# Script constants...
TODAYS_DATE=$(date "+%Y-%m-%d")
VM_FOLDER=/var/www
SHARED_HTML=$VM_FOLDER/html
PROVISION_FOLDER=$VM_FOLDER/provision
PROVISION_DATA=$VM_FOLDER/provision/data
PROVISION_HTML=$VM_FOLDER/provision/html
PROVISION_LOGS=$VM_FOLDER/provision/logs
PROVISION_SCRIPTS=$VM_FOLDER/provision/scripts
PROVISION_SSL=$VM_FOLDER/provision/ssl
PROVISION_TEMPLATES=$VM_FOLDER/provision/templates
PROVISION_VHOSTS=$VM_FOLDER/provision/vhosts

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/      Update & Install Packages      /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function update_package_lists () {
	echo "🔄 Updating package lists 🔄"
	if ! apt-get -q update 2>&1; then
		handle_error "Failed to update package lists"
	fi
}

# Function to upgrade packages if updates are available
function upgrade_packages () {
	if ! apt-get -q -s upgrade 2>&1 | grep -q '^[[:digit:]]\+ upgraded'; then
		announce_no_job "No packages to upgrade."
		return
	fi

	echo "⬆️ Upgrading packages ⬆️"
	if ! apt-get -qy upgrade 2>&1; then
		handle_error "Failed to upgrade packages"
	fi

	announce_success "Packages successfully upgraded."
}

# Function to install packages with error handling
# Usage: install_packages "$@"
function install_packages () {
	echo "🔄 Installing Packages 🔄"

	for package in "${PACKAGE_LIST[@]}"; do
		if ! apt-get -qy install "$package"; then
			handle_error "Failed to install packages"
		fi
	done

	announce_success "Packages installed successfully!"
}

# Function to remove unnecessary packages
function remove_unnecessary_packages () {
	if ! apt-get autoremove --dry-run | grep -q '^[[:digit:]]\+ packages will be removed'; then
		announce_no_job "No unnecessary packages to remove."
		return
	fi

	echo "🧹 Removing unnecessary packages 🧹"

	if ! apt-get -qy autoremove; then
		handle_error "Failed to remove unnecessary packages"
	fi

	announce_success "Unnecessary packages removed."
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/          Utility Functions          /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function for error handling
# Usage: handle_error "Error message"
function handle_error () {
	echo "⚠️ Error: $1 💥"
	echo "Run `vagrant halt` then restore the last snapshot before trying again."
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success () {
	icon="✅"

	if [ -n "$2" ] && [ "$2" -eq 1 ]; then
		icon="👍"
	fi

	echo "$icon $1"
}

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job () {
	echo "👍 $1"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/       Header & Footer Banners       /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Banner flags
ua="🇺🇦"
btbu=" 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
bt="$btbu$btbu$btbu$btbu$btbu"

# Function to write shalom peace salam banner
# Usage: peace_banner i - where i is 1 to 4
function peace_banner () {
	case $1 in
		1) # Binary
			echo "$ua      🕊️  01110011 01101000 01100001 01101100 01101111 01101101 🕊️"
			echo "$ua      🕊️  01110000 01100101 01100001 01100011 01100101          🕊️"
			echo "$ua      🕊️  01110011 01100001 01101100 01100001 01101101          🕊️"
			;;
		2) # Hexadecimal
			echo "$ua      🕊️  73 68 61 6C 6F 6D 🕊️"
			echo "$ua      🕊️  70 65 61 63 65    🕊️"
			echo "$ua      🕊️  73 61 6C 61 6D    🕊️"
			;;
		3) # Octal
			echo "$ua      🕊️  163 150 141 154 157 155 🕊️"
			echo "$ua      🕊️  160 145 141 143 145     🕊️"
			echo "$ua      🕊️  163 141 154 141 155     🕊️"
			;;
		4) # Morse Code
			echo "$ua      🕊️  ... .... .- .-.. --- -- 🕊️"
			echo "$ua      🕊️     .--. . .- -.-. .     🕊️"
			echo "$ua      🕊️     ... .- .-.. .- --    🕊️"
			;;
	esac
}

# Function to write header banner
# Usage: header_banner $active_title $script_name $updated_date
function header_banner () {
	echo "$ua$bt"
	echo "$ua"
	echo "$ua                        ___"
	echo "$ua                  _____|_  )                   _           _"
	echo "$ua         /\      |  __ \/ /                   (_)         | |"
	echo "$ua        /  \     | |__)/___|   _ __  _ __ ___  _  ___  ___| |_"
	echo "$ua       / /\ \    |  ___/      | '_ \| '__/ _ \| |/ _ \/ __| __|"
	echo "$ua      / ____ \   | |          | |_) | | | (_) | |  __/ (__| |_"
	echo "$ua     /_/    \_\  |_|          | .__/|_|  \___/| |\___|\___|\__|"
	echo "$ua                              | |            _/ |"
	echo "$ua                              |_|           |__/"
	echo "$ua"
	echo "$ua      🚀 $1 🚀"
	echo "$ua      📅     on $TODAYS_DATE"
	echo "$ua      📜 Script Name:  $2"
	echo "$ua      📅 Last Updated: $3"
	echo "$ua"
	echo "$ua$bt"
	echo ""
}

# Function to write footer banner
# Usage: footer_banner $job_complete
function footer_banner () {
	echo ""
	echo "$ua$bt"
	echo "$ua"
	echo "$ua      🏆 $1 ‼️"
	echo "$ua"
	peace_banner $((RANDOM % 4 + 1))
	echo "$ua"
	echo "$ua$bt"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

