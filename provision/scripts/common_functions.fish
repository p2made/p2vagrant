#!/bin/fish

# common_functions.fish
# Updated: 2024-02-12

# Script constants...
set TODAYS_DATE         (date "+%Y-%m-%d")
set VM_FOLDER           /var/www
set SHARED_HTML         $VM_FOLDER/html
set PROVISION_FOLDER    $VM_FOLDER/provision
set PROVISION_DATA      $VM_FOLDER/provision/data
set PROVISION_HTML      $VM_FOLDER/provision/html
set PROVISION_LOGS      $VM_FOLDER/provision/logs
set PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
set PROVISION_SSL       $VM_FOLDER/provision/ssl
set PROVISION_TEMPLATES $VM_FOLDER/provision/templates
set PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/      Update & Install Packages      /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to update package with error handling
# Usage: update_package_lists
function update_package_lists
	echo "🔄 Updating package lists 🔄"

	if not apt-get -q update > /dev/null 2>&1
		handle_error "Failed to update package lists"
	end

	announce_success "Package lists updated successfully."
end

# Function to install packages with error handling
# Usage: install_packages $package_list
function install_packages
	echo "🔄 Installing Packages 🔄"

	for package in $argv
		set cleaned (eval echo $package)
		if not apt-get -qy install $cleaned
			handle_error "Failed to install packages"
		end
	end

	announce_success "Packages installed successfully!"
end

# Function to update package lists the install packages with error handling
# invokes update_package_lists & install_packages in a single call
# Usage: update_and_install_packages $package_list
function update_and_install_packages
	update_package_lists
	install_packages $argv
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/           Configure Sites           /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to setup important site variables
# We can't return a value, so we put them in a global variable
# that we will quickly use & then erase.
# Usage: setup_site_variables $one_site
function setup_site_variables
	# Use the passed string $one_site to set a temporary global...
	# $site_info_temp[1-6], where...
	# $site_info_temp[1] is the domain
	# $site_info_temp[2] is the reverse domain
	# $site_info_temp[3] is the underscore domain
	# $site_info_temp[4] is the template filename
	# $site_info_temp[5] is the vhosts filename
	# $site_info_temp[6] is the SSL filename

	set split_string (string split ' ' $argv)

	set -g site_info_temp[1] $split_string[1]                          # 1 domain name

	set parts (string split '.' $split_string[1])

	for part in $parts
		set -p reversed $part
	end

	set -g site_info_temp[2] (string join "." $reversed)               # 2 reverse domain
	set -g site_info_temp[3] (string join "_" $reversed)               # 3 underscore domain

	set -g site_info_temp[4] $split_string[2].conf                     # 4 template filename

	if set -q split_string[3]
		set -g site_info_temp[5] $split_string[3]_
	else
		set -g site_info_temp[5] ""
	end

	set -g site_info_temp[5] $site_info_temp[5]$site_info_temp[3].conf # 5 vhosts filename
	set -g site_info_temp[6] $site_info_temp[3]_$TODAYS_DATE           # 6 SSL base filename
end

# Function to write the vhosts file from a template
# Usage: write_vhosts_file $domain $underscore_domain $template_filename $vhosts_filename $ssl_base_filename
function write_vhosts_file
	set domain            $argv[1]
	set underscore_domain $argv[2]
	set template_filename $argv[3]
	set vhosts_filename   $argv[4]
	set ssl_base_filename $argv[5]

	# Check if the template file exists
	if not test -f $PROVISION_TEMPLATES/$template_filename
		handle_error "Template file $template_filename.conf not found in $PROVISION_TEMPLATES"
	end

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		-e "s|{{DOMAIN}}|$domain|g" \
		-e "s|{{UNDERSCORE_DOMAIN}}|$underscore_domain|g" \
		-e "s|{{SSL_BASE_FILENAME}}|$ssl_base_filename|g" \
		-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
		$PROVISION_TEMPLATES/$template_filename > $PROVISION_VHOSTS/$vhosts_filename

	# Output progress message
	announce_success "Vhosts file for $domain created at $PROVISION_VHOSTS/$vhosts_filename"
end

# Function to generate SSL files
# Usage: generate_ssl_files $domain $ssl_base_filename
function generate_ssl_files
	set domain   $argv[1]
	set ssl_key  $PROVISION_SSL/$argv[2].key
	set ssl_cert $PROVISION_SSL/$argv[2].cert

	# Check if SSL folder exists
	if not test -d $PROVISION_SSL
		handle_error "SSL folder $PROVISION_SSL not found"
	end

	# Generate SSL key
	echo "🔄 Generating SSL key 🔄"
	if not openssl genrsa \
		-out $ssl_key \
		2048

		handle_error "Failed to generate SSL key for $domain"
	end

	# Output progress message
	announce_success "SSL key for $domain generated at $ssl_key."

	# Generate self-signed SSL certificate
	echo "🔄 Generating self-signed SSL certificate 🔄"
	if not openssl req -nodes -x509 \
		-key $ssl_key \
		-out $ssl_cert \
		-days 3650 \
		-subj "/CN=$domain"

		handle_error "Failed to generate self-signed SSL certificate for $domain"
	end

	# Output progress message
	announce_success "Self-signed SSL certificate for $domain generated at $ssl_cert."

	announce_success "SSL files for $domain generated successfully!"

	# Display information about the generated certificate
	openssl x509 -noout -text -in $ssl_cert
end

# Function to configure a website with everything done so far
# Usage: configure_website $site_info
function configure_website
	set domain            $argv[1]
	set site_folder       $VM_FOLDER/$argv[2]
	set vhosts_filename   $argv[3]
	set ssl_base_filename $argv[4]

	# Put `conf` & SSL files into place
	sudo cp -f $PROVISION_VHOSTS/$vhosts_filename  /etc/apache2/sites-available/
	sudo cp -f $PROVISION_SSL/$ssl_base_filename.* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p $site_folder

	# Copy files only if they do not exist
	set files_to_copy "index.html" "index.php" "phpinfo.php" "db.php"
	for file in $files_to_copy
		cp -u $PROVISION_HTML/$file $site_folder/
	end

	# Enable site
	sudo a2ensite $vhosts_filename

	# Output progress message
	echo "Website configured for $domain"
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/          Utility Functions          /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function for error handling
# Use without closing punctuation on the message.
# Usage: handle_error "Error message"
function handle_error
	echo "⚠️ Error: $argv 💥"
	echo "Run `vagrant halt` then restore the last snapshot before trying again."
	exit 1
end

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success
	set icon "✅"

	if test -n "$argv[2]" && ["$argv[2]" -eq 1]
		set icon "👍"
	end

	echo "$icon $argv[1]"
end

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job
	echo "👍 $1"
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/       Header & Footer Banners       /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Banner flags
set ua "🇺🇦"
set btbu " 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
set btb $btbu$btbu$btbu$btbu$btbu

# Function to write shalom peace salam banner
# Usage: peace_banner i - where i is 1 to 4
function peace_banner
	switch $argv[1]
		case 1 # Binary
			echo "$ua      🕊️  01110011 01101000 01100001 01101100 01101111 01101101 🕊️"
			echo "$ua      🕊️  01110000 01100101 01100001 01100011 01100101          🕊️"
			echo "$ua      🕊️  01110011 01100001 01101100 01100001 01101101          🕊️"
		case 2 # Hexadecimal
			echo "$ua      🕊️  73 68 61 6C 6F 6D 🕊️"
			echo "$ua      🕊️  70 65 61 63 65    🕊️"
			echo "$ua      🕊️  73 61 6C 61 6D    🕊️"
		case 3 # Octal
			echo "$ua      🕊️  163 150 141 154 157 155 🕊️"
			echo "$ua      🕊️  160 145 141 143 145     🕊️"
			echo "$ua      🕊️  163 141 154 141 155     🕊️"
		case 4 # Morse Code
			echo "$ua      🕊️  ... .... .- .-.. --- -- 🕊️"
			echo "$ua      🕊️     .--. . .- -.-. .     🕊️"
			echo "$ua      🕊️     ... .- .-.. .- --    🕊️"
	end
end

# Function to write header banner
# Usage: header_banner $active_title $script_name $updated_date
function header_banner
	echo "$ua$btb"
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
	echo "$ua      🚀 $argv[1] 🚀"
	echo "$ua      📅     on $TODAYS_DATE"
	echo "$ua"
	echo "$ua      📜 Script Name:  $argv[2]"
	echo "$ua      📅 Last Updated: $argv[3]"
	echo "$ua"
	echo "$ua$btb"
	echo ""
end

# Function to write footer banner
# Usage: footer_banner $job_complete
function footer_banner
	echo ""
	echo "$ua$btb"
	echo "$ua"
	echo "$ua      🏆 $argv[1] ‼️"
	echo "$ua"
	peace_banner (math (random) % 4 + 1)
	echo "$ua"
	echo "$ua$btb"
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

