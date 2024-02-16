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
# Usage: setup_site_variables $one_site
#function setup_site_variables () {
	# Use the passed string $one_site to set a temporary global...
	# $site_info_temp[1-6], where...
	# $site_info_temp[1] is the domain
	# $site_info_temp[2] is the reverse domain
	# $site_info_temp[3] is the underscore domain
	# $site_info_temp[4] is the template filename
	# $site_info_temp[5] is the vhosts filename
	# $site_info_temp[6] is the SSL filename

#}

# Function to write the vhosts file from a template
# Usage: generate_vhosts_file $domain $underscore_domain $template_filename $vhosts_filename $ssl_base_filename
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
# Usage: generate_ssl_files $domain $ssl_base_filename
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

	announce_success "SSL files for $domain generated successfully!"

	# Display information about the generated certificate
	openssl x509 -noout -text -in "$ssl_cert"
}

# Function to configure a website with everything done so far
# Usage: configure_website $domain $underscore_domain $vhosts_filename $ssl_base_filename
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

	local web_files=("index.md" "index.htm" "index.html")

	# Check if $2 is not "html"
	if [ "$2" != "html" ]; then
		web_files+=("index.php" "phpinfo.php" "db.php")
	fi

	# Copy only if a file of the same name is not present
	for file in "${web_files[@]}"; do
		if [ ! -e "$site_folder/$file" ]; then
			cp "$PROVISION_HTML/$file" "$site_folder/"
		fi
	done

	# Set permissions on web server files
	chmod -R 755 "$site_folder"/*

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

