#!/bin/bash

# _sites.sh

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/         Sites Configuration         /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to setup important site variables
# We can't return a value, so we put them in a global
# variable that we will quickly use & then erase.
# Usage: setup_site_variables "$domain_name" "$template_index" "$vhosts_prefix"
function setup_site_variables {
	# Use the passed string $domain_name to set a temporary global...
	# $site_info_temp[1-6], where...
	# $site_info_temp[1] is the domain
	# $site_info_temp[2] is the reverse domain
	# $site_info_temp[3] is the underscore domain
	# $site_info_temp[4] is the template filename
	# $site_info_temp[5] is the vhosts filename
	# $site_info_temp[6] is the SSL filename

	# Reversing the domain
	site_info_temp[2]=$(echo "$1" | awk -F'.' '{for(i=NF;i>0;i--) printf "%s.", $i; printf "\n"}' | sed 's/\.$//')

	# Removing leading and trailing spaces from reversed domain
	site_info_temp[2]=$(echo "${site_info_temp[2]}" | sed 's/^ *//;s/ *$//')

	# Replacing spaces with underscores in the reversed domain
	site_info_temp[3]=$(echo "${site_info_temp[2]}" | sed 's/ /_/g')

	# Reversing the domain
	site_info_temp[2]=$(echo "$1" | awk -F'.' '{for(i=NF;i>0;i--) printf "%s.", $i; printf "\n"}' | sed 's/\.$//')

	# Replacing spaces with underscores in the reversed domain
	site_info_temp[3]=$(echo "${site_info_temp[2]}" | sed 's/ /_/g')

	site_info_temp[4]="$2.conf"                            # 4 template filename

	if [ -n "$3" ]; then
		site_info_temp[5]="${3}_${site_info_temp[3]}.conf"  # 5 vhosts filename
	else
		site_info_temp[5]="${site_info_temp[3]}.conf"                   # 5 vhosts filename without prefix
	fi

	site_info_temp[6]="${site_info_temp[3]}_$TODAYS_DATE"               # 6 SSL base filename
}

function setup_site_variables {
	# Use the passed string $domain_name to set a temporary global...
	# $site_info_temp[1-6], where...
	# $site_info_temp[1] is the domain
	# $site_info_temp[2] is the reverse domain
	# $site_info_temp[3] is the underscore domain
	# $site_info_temp[4] is the template filename
	# $site_info_temp[5] is the vhosts filename
	# $site_info_temp[6] is the SSL filename

	local domain_name=$1
	local template_index=$2
	local vhosts_prefix=$3

	debug_message "$LINENO" "\$domain_name is $domain_name"
	debug_message "$LINENO" "\$template_index is $template_index"
	debug_message "$LINENO" "\$vhosts_prefix is $vhosts_prefix"

	site_info_temp[1]="$domain_name"                                    # 1 domain name

	IFS='.' read -ra parts <<< "$domain_name"
	reversed=""
	for part in "${parts[@]}"; do
		reversed="$part $reversed"
	done

	site_info_temp[2]=$(echo "$reversed" | sed 's/ $//')                # 2 reverse domain
	site_info_temp[3]=$(echo "$reversed" | sed 's/ /_/g')               # 3 underscore domain

	site_info_temp[4]="$template_index.conf"                            # 4 template filename

	if [ -n "$vhosts_prefix" ]; then
		site_info_temp[5]="${vhosts_prefix}_${site_info_temp[3]}.conf"  # 5 vhosts filename
	else
		site_info_temp[5]="${site_info_temp[3]}.conf"                   # 5 vhosts filename without prefix
	fi

	site_info_temp[6]="${site_info_temp[3]}_$TODAYS_DATE"               # 6 SSL base filename
}

# Function to write the vhosts file from a template
# Usage: generate_vhosts_file "$domain" "$underscore_domain" "$template_filename" "$vhosts_filename" "$ssl_base_filename"
function generate_vhosts_file() {
	local domain="$1"
	local underscore_domain="$2"
	local template_filename="$3"
	local vhosts_filename="$4"
	local ssl_base_filename="$5"

	# Check if the template file exists
	if [ ! -f "$PROVISION_TEMPLATES/$template_filename" ]; then
		handle_error "Template file $template_filename.conf not found in $PROVISION_TEMPLATES"
	fi

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		-e "s|{{DOMAIN}}|$domain|g" \
		-e "s|{{UNDERSCORE_DOMAIN}}|$underscore_domain|g" \
		-e "s|{{SSL_BASE_FILENAME}}|$ssl_base_filename|g" \
		-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
		-e "s|{{VM_LOGS_FOLDER}}|$VM_LOGS_FOLDER|g" \
		"$PROVISION_TEMPLATES/$template_filename" > "$PROVISION_VHOSTS/$vhosts_filename"

	# Output progress message
	announce_success "Vhosts file for $domain created at $PROVISION_VHOSTS/$vhosts_filename"
}

# Function to generate SSL files
# Usage: generate_ssl_files "$domain" "$ssl_base_filename"
function generate_ssl_files() {
	local domain="$1"
	local ssl_key="$PROVISION_SSL/$2.key"
	local ssl_cert="$PROVISION_SSL/$2.cert"

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
	if ! openssl req -nodes -x509 \
		-key "$ssl_key" \
		-out "$ssl_cert" \
		-days 3650 \
		-subj "/CN=$domain"; then
		handle_error "Failed to generate self-signed SSL certificate for $domain"
	fi

	# Output progress message
	announce_success "Self-signed SSL certificate for $domain generated at $ssl_cert."

	# Display information about the generated certificate
	openssl x509 -noout -text -in "$ssl_cert"
}

# Function to write index files from a template
# Usage: generate_web_files "$target_folder" "${web_files[@]}"
function generate_web_files() {
	local target_folder="$1"
	shift

	# Check if the template file exists
	if [ ! -f "$PROVISION_TEMPLATES/$template_filename" ]; then
		handle_error "Template file $template_filename not found in $PROVISION_TEMPLATES"
	fi

	for template_filename in "$@"; do
		# Check if the template file exists
		if [ ! -f "$PROVISION_TEMPLATES/$template_filename" ]; then
			handle_error "Template file $template_filename not found in $PROVISION_TEMPLATES"
		fi

		# Use sed to replace placeholders in the template and save it to the new file
		sed \
			-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
			-e "s|{{VM_HOSTNAME}}|$VM_HOSTNAME|g" \
			-e "s|{{DB_USERNAME}}|$DB_USERNAME|g" \
			-e "s|{{DB_PASSWORD}}|$DB_PASSWORD|g" \
			-e "s|{{DB_NAME}}|$DB_NAME|g" \
			"$PROVISION_TEMPLATES/$template_filename" > "$PROVISION_HTML/$template_filename"

		mv "$PROVISION_HTML/$template_filename" "$target_folder/" ||
			handle_error "Failed to move $template_filename file"
	done
}

# Function to configure a website with everything done so far
# Usage: configure_website "$domain" "$underscore_domain" "$vhosts_filename" "$ssl_base_filename"
function configure_website() {
	local domain="$1"
	local site_folder="$VM_FOLDER/$2"
	local vhosts_filename="$3"
	local ssl_base_filename="$4"

	# Put `conf` & SSL files into place
	sudo cp -f "$PROVISION_VHOSTS/$vhosts_filename" /etc/apache2/sites-available/
	sudo cp -f "$PROVISION_SSL/$ssl_base_filename".* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p "$site_folder"

	local web_files=("index.md" "index.htm")
	generate_web_files "$site_folder" "${web_files[@]}"
	cp -n "$PROVISION_HTML/index.html" "$site_folder/"

	# Check if $2 is not "html"
	if [ "$2" != "html" ]; then
		web_files=("db.php" "index.php")
		generate_web_files "$site_folder" "${web_files[@]}"
		cp "$PROVISION_HTML/phpinfo.php" "$site_folder/"
	fi

	# Set permissions on web server files
	chmod -R 755 "$site_folder"/*

	# Enable site
	sudo a2ensite "$vhosts_filename"

	# Output progress message
	announce_success "Website configured for $domain"
}

# Example usage:
# one_site="example.com templatefile outputfile"
# setup_site_variables "$one_site"
# write_vhosts_file "${site_info_temp[@]}"
# generate_ssl_files "${site_info_temp[@]}"
# configure_website "${site_info_temp[@]}"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# debug_message "$LINENO" "Message"
