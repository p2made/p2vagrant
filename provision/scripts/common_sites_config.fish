#!/bin/fish

# common_sites_config.fish
# Updated: 2024-02-04

# Script constants...

# Function to write the vhosts file from a template
# Usage: write_vhosts_file $site_info
function write_vhosts_file
	set domain            $argv[1]
	set underscore_domain $argv[2]
	set template_filename $argv[3]
	set vhosts_filename   $argv[4]
	set ssl_filename      $argv[5]

	# Check if the template file exists
	if not test -f $PROVISION_TEMPLATES/$template_filename
		handle_error "Template file $template_filename not found in $PROVISION_TEMPLATES"
	end

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		-e "s|{{DOMAIN}}|$domain|g" \
		-e "s|{{UNDERSCORE_DOMAIN}}|$underscore_domain|g" \
		-e "s|{{SSL_FILENAME}}|$ssl_filename|g" \
		-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
		$PROVISION_TEMPLATES/$template_filename > $PROVISION_VHOSTS/$vhosts_filename

	# Output progress message
	echo "Vhosts file for $domain created at $PROVISION_VHOSTS/$vhosts_filename"
end

# Function to generate SSL files
# Usage: generate_ssl_files $site_info $ssl_prefix
function generate_ssl_files
	set ssl_key  $PROVISION_SSL/$argv[2].key
	set ssl_cert $PROVISION_SSL/$argv[2].cert
	set domain   $argv[1]

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
	echo "SSL key for $domain generated at $ssl_key"

	# Generate self-signed SSL certificate
	echo "🔄 Generating self-signed SSL certificate 🔄"
	# Generate self-signed SSL certificate
	if not openssl req -x509 -nodes \
		-key $ssl_key \
		-out $ssl_cert \
		-days 3650 \
		-subj "/CN=$domain" 2>/dev/null
		handle_error "Failed to generate self-signed SSL certificate for $domain"
	end
	# Output progress message
	echo "SSL certificate for $domain generated at $ssl_cert"

	announce_success "SSL files for $domain generated successfully!"

	# Display information about the generated certificate
	openssl x509 -noout -text -in $ssl_cert
end

# Function to configure a website with everything done so far
# Usage: configure_website $site_info
function configure_website
	set domain            $argv[1]
	set underscore_domain $argv[2]
	set vhosts_filename   $argv[3]
	set ssl_filename      $argv[4]

	# Put `conf` & SSL files into place
	sudo cp -f $PROVISION_VHOSTS/$vhosts_filename /etc/apache2/sites-available/
	sudo cp -f $PROVISION_SSL/$ssl_filename.* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p $VM_FOLDER/$underscore_domain

	# Copy files only if they do not exist
	set files_to_copy "index.html" "index.php" "phpinfo.php" "db.php"
	for file in $files_to_copy
		cp -u $PROVISION_HTML/$file $VM_FOLDER/$underscore_domain/
	end

	# Enable site
	sudo a2ensite $vhosts_filename

	# Output progress message
	echo "Website configured for $domain"
end
