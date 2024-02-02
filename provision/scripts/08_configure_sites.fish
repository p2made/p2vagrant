#!/bin/fish

# 00 _script_title_

set script_name     "08_configure_sites.fish"
set updated_date    "2024-02-02"

set active_title    "Configuring Websites"
set job_complete    "Websites Configured"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# NONE!"

# Script variables...

# Array of site data
set sites \
	"example.test 1" \
	"subdomain1.example.test 0" \
	"subdomain2.example.test 0"

set -x DEBIAN_FRONTEND noninteractive

# Start _script_title_ logic...

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to generate the conf files and SSL files
function configure_site
	# $argv[1] - domain
	# $argv[2] - template index
	# $argv[3] - reverse domain
	# $argv[4] - underscore domain
	# $argv[5] - ssl filename

	# For readability, set $argv parts to discrete variables
	set domain              $argv[1]
	set template_index      $argv[2]
	set reverse_domain      $argv[3]
	set underscore_domain   $argv[4]
	set ssl_filename        $argv[5]

	# Select the appropriate template based on the numeric value
	set template_file $PROVISION_TEMPLATES/$template_index.conf
	set vhosts_file $PROVISION_VHOSTS/$underscore_domain.conf

	# Check if the template file exists
	if not test -f $template_file
		handle_error "Template file $template_index.conf not found in $PROVISION_TEMPLATES"
	end

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		"s|{{DOMAIN}}|$domain|g; \
		s|{{UNDERSCORE_DOMAIN}}|$underscore_domain|g; \
		s|{{GENERATION_DATE}}|$TODAYS_DATE|g" $template_file > $vhosts_file

	# Check if SSL folder exists
	if not test -d $PROVISION_SSL
		handle_error "SSL folder $PROVISION_SSL not found"
	end

	# Set paths for SSL certificate and key
	set ssl_cert_file $PROVISION_SSL/$ssl_filename.cert
	set ssl_key_file $PROVISION_SSL/$ssl_filename.key

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

	# Put `conf` & SSL files into place
	sudo cp -f $vhosts_file /etc/apache2/sites-available/
	sudo cp -f $PROVISION_SSL/$ssl_filename.* /etc/apache2/sites-available/

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

# Iterate through the site data
for one_site in $sites
	# First get thy data in order young coder
	set site_info (string split ' ' $one_site)
	set domain $site_info[1]
	set template_index $site_info[2]

	set parts_orig (string split '.' $domain)

	for part in $parts_orig
		set -p reversed_parts $part
	end

	set reverse_domain (string join "." $reversed_parts)
	set underscore_domain (string join "_" $reversed_parts)
	set ssl_filename "$reversed_parts"_"$TODAYS_DATE"

	# Now go configure some web sites
	configure_site \
		$domain \
		$template_index \
		$reverse_domain \
		$underscore_domain \
		$ssl_filename
end

# Restart Apache after all configurations
sudo service apache2 restart

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
