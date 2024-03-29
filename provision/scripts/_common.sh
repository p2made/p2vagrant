#!/bin/bash

# _common.sh

# Script constants...
TODAYS_DATE=$(date "+%Y-%m-%d")
#TODAYS_DATE=$(env TZ=Australia/Brisbane date "+%Y-%m-%d")
VM_HOSTNAME=$(hostname)
VM_FOLDER=/var/www         # Inherited from p2v_data.sh
SHARED_HTML=$VM_FOLDER/html
PROVISION_FOLDER=$VM_FOLDER/provision
PROVISION_DATA=$VM_FOLDER/provision/data
PROVISION_HTML=$VM_FOLDER/provision/html
PROVISION_LOGS=$VM_FOLDER/provision/logs
PROVISION_SCRIPTS=$VM_FOLDER/provision/scripts
PROVISION_SSL=$VM_FOLDER/provision/ssl
PROVISION_TEMPLATES=$VM_FOLDER/provision/templates
PROVISION_VHOSTS=$VM_FOLDER/provision/vhosts
VM_LOGS_FOLDER=$VM_FOLDER/vm_logs

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/          Utility Functions          /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function for error handling
# Usage: handle_error "Error message"
function handle_error() {
	echo "⚠️  Error: $1 💥"
	echo "Run 'vagrant halt' then restore the last snapshot before trying again."
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success() {
	icon="✅"

	if [ -n "$2" ] && [ "$2" -eq 1 ]; then
		icon="👍"
	fi

	echo "$icon  $1"
}

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job() {
	echo "👍  $1"
}

# Function to give a debugging message
# Usage: debug_message "$LINENO" "Message"
function debug_message() {
	local calling_function="${FUNCNAME[1]}"
	echo "‼️‼️  Debug in $calling_function at line $1: $2 🚨"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/         Packages Management         /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function update_package_lists() {
	echo "🔄 Updating package lists 🔄"

	if ! apt-get -q update 2>&1; then
		handle_error "Failed to update package lists"
	fi

	announce_success "Package lists updated successfully."
}

# Function to upgrade packages if updates are available
# Usage: upgrade_packages
function upgrade_packages() {
	echo "⬆️ Upgrading packages ⬆️"

	# Check if there are packages to upgrade
	if ! apt-get -q -s upgrade 2>&1 | grep -q '^[[:digit:]]\+ upgraded'; then
		announce_no_job "No packages to upgrade."
		return
	fi

	# Actually perform the upgrade
	if ! apt-get -qy upgrade 2>&1; then
		handle_error "Failed to upgrade packages"
	fi

	announce_success "Packages successfully upgraded."
}

# Function to install packages with error handling
# Usage: install_packages "${package_list[@]}"
function install_packages() {
	echo "🔄 Installing Packages 🔄"

	for package in "${@}"; do
		if ! apt-get -qy install "$package"; then
			handle_error "Failed to install packages"
		fi
	done

	announce_success "Packages installed successfully!"
}

# Function to remove unnecessary packages
function remove_unnecessary_packages() {
	echo "🧹 Removing unnecessary packages 🧹"

	# Check if there are packages to remove
	if ! apt-get autoremove --dry-run | grep -q '^[[:digit:]]\+ packages will be removed'; then
		announce_no_job "No unnecessary packages to remove."
		return
	fi

	# Actually remove them
	if ! apt-get -qy autoremove; then
		handle_error "Failed to remove unnecessary packages"
	fi

	announce_success "Unnecessary packages removed."
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/          Banner Functions           /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to write header banner
# Usage: header_banner "$active_title" "$script_name" "$updated_date" $upgrade
function header_banner() {
	local active_title=$1
	local script_name=$2
	local updated_date=$3
	local upgrade=$4
	cat "$VM_FOLDER/provision/vm/txt/art_flags.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_ua.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_p2vagrant.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_ua.txt"
	if $upgrade; then
		cat "$VM_FOLDER/provision/vm/txt/art_p2project.txt"
		cat "$VM_FOLDER/provision/vm/txt/art_ua.txt"
	fi
	sed -e "s|{{active_title}}|$(echo "$active_title" | sed 's|&|\\&|g')|g" \
		-e "s|{{script_name}}|$script_name|g" \
		-e "s|{{updated_date}}|$updated_date|g" \
		-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
			"$VM_FOLDER/provision/vm/txt/art_details.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_ua.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_flags.txt"
	echo ""
}

# Function to write footer banner
# Usage: footer_banner $job_complete
function footer_banner() {
	local job_complete=$1
	echo ""
	cat "$VM_FOLDER/provision/vm/txt/art_flags.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_ua.txt"
	sed "s|{{job_complete}}|$(echo "$job_complete" | sed 's|&|\\&|g')|g" \
		"$VM_FOLDER/provision/vm/txt/art_complete.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_ua.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_copyright.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_ua.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_peace_$(( RANDOM % 4 )).txt"
	cat "$VM_FOLDER/provision/vm/txt/art_ua.txt"
	cat "$VM_FOLDER/provision/vm/txt/art_flags.txt"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

