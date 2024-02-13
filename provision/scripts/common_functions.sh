#!/bin/bash

# common_functions.sh
# Updated: 2024-02-14

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
# -- -- /%/ -- -- /%/         Packages Management         /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function update_package_lists () {
	echo "🔄 Updating package lists 🔄"
	if ! apt-get -q update 2>&1; then
		handle_error "Failed to update package lists"
	fi

	announce_success "Package lists updated successfully."
}

# Function to upgrade packages if updates are available
# Usage: upgrade_packages
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

# Function to update package lists the install packages with error handling
# invokes update_package_lists & install_packages in a single call
# Usage: update_and_install_packages $package_list
function update_and_install_packages () {
	update_package_lists
	install_packages $argv
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
# -- -- /%/ -- -- /%/         Sites Configuration         /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to setup important site variables
# We can't return a value, so we put them in a global
# variable that we will quickly use & then erase.
# Usage: setup_site_variables $one_site
function setup_site_variables {
	# Use the passed string $one_site to set a temporary global...
	# $site_info_temp[1-6], where...
	# $site_info_temp[1] is the domain
	# $site_info_temp[2] is the reverse domain
	# $site_info_temp[3] is the underscore domain
	# $site_info_temp[4] is the template filename
	# $site_info_temp[5] is the vhosts filename
	# $site_info_temp[6] is the SSL filename

	IFS=' ' read -ra split_string <<< "$1"

	site_info_temp[1]=${split_string[1]}                          # 1 domain name

	IFS='.' read -ra parts <<< "${split_string[1]}"
	reversed=""
	for part in "${parts[@]}"; do
		reversed="$part $reversed"
	done

	site_info_temp[2]=$(echo "$reversed" | sed 's/ $//')          # 2 reverse domain
	site_info_temp[3]=$(echo "$reversed" | sed 's/ /_/g')         # 3 underscore domain

	site_info_temp[4]="${split_string[2]}.conf"                   # 4 template filename

	if [ -n "${split_string[3]}" ]; then
		site_info_temp[5]="${split_string[3]}_"
	else
		site_info_temp[5]=""
	fi

	site_info_temp[5]="${site_info_temp[5]}${site_info_temp[3]}.conf"  # 5 vhosts filename
	site_info_temp[6]="${site_info_temp[3]}_$TODAYS_DATE"             # 6 SSL base filename
}

# Function to write the vhosts file from a template
# Usage: write_vhosts_file $domain $underscore_domain $template_filename $vhosts_filename $ssl_base_filename
function write_vhosts_file {
	domain=$1
	underscore_domain=$2
	template_filename=$3
	vhosts_filename=$4
	ssl_base_filename=$5

	# Check if the template file exists
	if [ ! -f "$PROVISION_TEMPLATES/$template_filename" ]; then
		handle_error "Template file $template_filename.conf not found in $PROVISION_TEMPLATES"
	fi

	# Use sed to replace placeholders in the template and save it to the new file
	sed -e "s|{{DOMAIN}}|$domain|g" \
		-e "s|{{UNDERSCORE_DOMAIN}}|$underscore_domain|g" \
		-e "s|{{SSL_BASE_FILENAME}}|$ssl_base_filename|g" \
		-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
		"$PROVISION_TEMPLATES/$template_filename" > "$PROVISION_VHOSTS/$vhosts_filename"

	# Output progress message
	announce_success "Vhosts file for $domain created at $PROVISION_VHOSTS/$vhosts_filename"
}

# Function to generate SSL files
# Usage: generate_ssl_files $domain $ssl_base_filename
function generate_ssl_files {
	domain=$1
	ssl_key="$PROVISION_SSL/$2.key"
	ssl_cert="$PROVISION_SSL/$2.cert"

	# Check if SSL folder exists
	if [ ! -d "$PROVISION_SSL" ]; then
		handle_error "SSL folder $PROVISION_SSL not found"
	fi

	# Generate SSL key
	echo "🔄 Generating SSL key 🔄"
	if ! openssl genrsa -out "$ssl_key" 2048; then
		handle_error "Failed to generate SSL key for $domain"
	fi

	# Output progress message
	announce_success "SSL key for $domain generated at $ssl_key."

	# Generate self-signed SSL certificate
	echo "🔄 Generating self-signed SSL certificate 🔄"
	if ! openssl req -nodes -x509 -key "$ssl_key" -out "$ssl_cert" -days 3650 -subj "/CN=$domain"; then
		handle_error "Failed to generate self-signed SSL certificate for $domain"
	fi

	# Output progress message
	announce_success "Self-signed SSL certificate for $domain generated at $ssl_cert."

	announce_success "SSL files for $domain generated successfully!"

	# Display information about the generated certificate
	openssl x509 -noout -text -in "$ssl_cert"
}

# Function to configure a website with everything done so far
# Usage: configure_website $domain $underscore_domain $vhosts_filename $ssl_base_filename
function configure_website {
	domain=$1
	site_folder="$VM_FOLDER/$2"
	vhosts_filename=$3
	ssl_base_filename=$4

	# Put `conf` & SSL files into place
	sudo cp -f "$PROVISION_VHOSTS/$vhosts_filename" /etc/apache2/sites-available/
	sudo cp -f "$PROVISION_SSL/$ssl_base_filename".* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p "$site_folder"

	web_files=("index.md" "index.htm" "index.html")

	# Check if argv[2] is not "html"
	if [ "$2" != "html" ]; then
		web_files+=("index.php" "phpinfo.php" "db.php")
	fi

	for file in "${web_files[@]}"; do
		cp -u "$PROVISION_HTML/$file" "$site_folder/"
	done

	# Enable site
	sudo a2ensite "$vhosts_filename"

	# Output progress message
	echo "Website configured for $domain"
}

# Example usage:
# one_site="example.com templatefile outputfile"
# setup_site_variables "$one_site"
# write_vhosts_file "${site_info_temp[@]}"
# generate_ssl_files "${site_info_temp[@]}"
# configure_website "${site_info_temp[@]}"

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

# Function to write banner opening
# Usage: banner_open
function banner_open () {
	echo "$ua$btb"
	echo "$ua"
}

# Function to write banner closing
# Usage: banner_close
function banner_close () {
	echo "$ua"
	echo "$ua$btb"
}

# Usage: banner_p2vagrant
function banner_p2vagrant () {
	echo "$ua                     ___                                     __"
	echo "$ua               ____ |__ \_   ______ _____ __________ _____  / /_"
	echo "$ua              / __ \__/ / | / / __ `/ __ `/ ___/ __ `/ __ \/ __/"
	echo "$ua             / /_/ / __/| |/ / /_/ / /_/ / /  / /_/ / / / / /_"
	echo "$ua            / .___/____/|___/\__,_/\__, /_/   \__,_/_/ /_/\__/"
	echo "$ua           /_/                    /____/"
}

# Usage: banner_p2project
function banner_p2project () {
	echo "$ua                             _"
	echo "$ua                            (_)____   ____ _"
	echo "$ua                           / / ___/  / __ `/"
	echo "$ua                          / (__  )  / /_/ /   _ _ _"
	echo "$ua                         /_/____/   \__,_/   (_|_|_)"
	echo "$ua"
	echo "$ua                             ___"
	echo "$ua                       _____|_  )                   _           _"
	echo "$ua              /\      |  __ \/ /                   (_)         | |"
	echo "$ua             /  \     | |__)/___|   _ __  _ __ ___  _  ___  ___| |_"
	echo "$ua            / /\ \    |  ___/      | '_ \| '__/ _ \| |/ _ \/ __| __|"
	echo "$ua           / ____ \   | |          | |_) | | | (_) | |  __/ (__| |_"
	echo "$ua          /_/    \_\  |_|          | .__/|_|  \___/| |\___|\___|\__|"
	echo "$ua                                   | |            _/ |"
	echo "$ua                                   |_|           |__/"
}

# Usage: banner_details $active_title $script_name $updated_date
function banner_details () {
	echo "$ua           🚀 $argv[1] 🚀"
	echo "$ua           📅     on $TODAYS_DATE"
	echo "$ua"
	echo "$ua           📜 Script Name:  $argv[2]"
	echo "$ua           📅 Last Updated: $argv[3]"
}

# Function to write shalom peace salam banner
# Usage: peace_banner i - where i is 1 to 4
function peace_banner () {
	case $1 in
		1) # Binary
			echo "$ua           🕊️  01110011 01101000 01100001 01101100 01101111 01101101 🕊️"
			echo "$ua           🕊️  01110000 01100101 01100001 01100011 01100101          🕊️"
			echo "$ua           🕊️  01110011 01100001 01101100 01100001 01101101          🕊️"
			;;
		2) # Hexadecimal
			echo "$ua           🕊️  73 68 61 6C 6F 6D 🕊️"
			echo "$ua           🕊️  70 65 61 63 65    🕊️"
			echo "$ua           🕊️  73 61 6C 61 6D    🕊️"
			;;
		3) # Octal
			echo "$ua           🕊️  163 150 141 154 157 155 🕊️"
			echo "$ua           🕊️  160 145 141 143 145     🕊️"
			echo "$ua           🕊️  163 141 154 141 155     🕊️"
			;;
		4) # Morse Code
			echo "$ua           🕊️  ... .... .- .-.. --- -- 🕊️"
			echo "$ua           🕊️     .--. . .- -.-. .     🕊️"
			echo "$ua           🕊️     ... .- .-.. .- --    🕊️"
			;;
	esac
}

# Function to write update banner
# Usage: update_banner $active_title $script_name $updated_date
function update_banner () {
	banner_open
	banner_p2vagrant
	echo "$ua"
	banner_p2project
	echo "$ua"
	banner_details $argv
	banner_close
	echo ""
}

# Function to write header banner
# Usage: header_banner $active_title $script_name $updated_date
function header_banner () {
	banner_open
	banner_p2vagrant
	echo "$ua"
	banner_details $argv
	banner_close
	echo ""
}

# Function to write footer banner
# Usage: footer_banner $job_complete
function footer_banner () {
	echo ""
	banner_open
	echo "$ua           🏆 $argv[1] ‼️"
	echo "$ua"
	peace_banner (math (random) % 4 + 1)
	banner_close
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

