#!/bin/fish

# 09 Configure Sites

set script_name     "configure_sites.fish"
set updated_date    "2024-02-03"

set active_title    "Configuring Websites"
set job_complete    "Websites Configured"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# NONE!"

# File path for site data
set site_data_file "/var/www/provision/data/sites_data"

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function set_site_variables
	set site_info (string split ' ' $argv[1])

	set -g domain $site_info[1]
	set -g template_num $site_info[2]

	#set -g vhosts_prefix false
	if count $site_info > 2
		set -g vhosts_prefix "$site_info[3]_"
	end

	set parts (string split '.' $domain)

	for part in $parts
		set -p reversed $part
	end

	set -g reverse_domain (string join "." $reversed)
	set -g underscore_domain (string join "_" $reversed)
end

function write_vhosts_file
	# Select the appropriate template based on the numeric value
	set template_file $PROVISION_TEMPLATES/$template_num.conf

	# Set path for vhosts file
	set vhosts_file $PROVISION_VHOSTS/$vhosts_prefix$underscore_domain.conf

	# Check if the template file exists
	if not test -f $template_file
		handle_error "Template file $template_num.conf not found in $PROVISION_TEMPLATES"
	end

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		"s|{{DOMAIN}}|$domain|g; \
		s|{{UNDERSCORE_DOMAIN}}|$underscore_domain|g; \
		s|{{TODAYS_DATE}}|$TODAYS_DATE|g" $template_file > $vhosts_file
end

function generate_ssl_files
	# Check if SSL folder exists
	if not test -d $PROVISION_SSL
		handle_error "SSL folder $PROVISION_SSL not found"
	end

	# Set paths for SSL certificate and key
	set ssl_root_string "$PROVISION_SSL/$underscore_domain"_"$TODAYS_DATE"
	set ssl_cert_file $ssl_root_string.cert
	set ssl_key_file $ssl_root_string.key

	# Generate SSL key
	openssl genrsa \
		-out $ssl_key_file \
		2048

	# Generate self-signed SSL certificate
	openssl req -new -x509 \
		-key $ssl_key_file \
		-out $ssl_cert_file \
		-days 3650 \
		-subj /CN=$domain
end

function configure_website
	# Put `conf` & SSL files into place
	sudo cp -f $vhosts_file /etc/apache2/sites-available/
	sudo cp -f $ssl_root_string.* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p $VM_FOLDER/$underscore_domain

	# Copy files only if they do not exist
	set files_to_copy "index.html" "phpinfo.php" "db.php"
	for file in $files_to_copy
		cp -u $PROVISION_HTML/$file $VM_FOLDER/$underscore_domain/
	end

	# Enable site
	sudo a2ensite $underscore_domain
end

function erase_site_variables
	set -e domain
	set -e template_num
	set -e vhosts_prefix
	set -e reverse_domain
	set -e underscore_domain
end

# Iterate through the site data
for one_site in (cat $site_data_file | grep -v '^#')
	# First get thy data in order, young coder
	set_site_variables $one_site

	# Now we have variables...
	# $domain
	# $template_num
	# $vhosts_prefix
	# $reverse_domain
	# $underscore_domain

	# Now go configure some web sites
	write_vhosts_file
	generate_ssl_files
	configure_website

	# Reset for the next site
	erase_site_variables
end

# Restart Apache after all configurations
sudo service apache2 restart

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
