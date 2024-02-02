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
function configure_sites
	# $argv[1] - domain
	# $argv[2] - template index
	# $argv[3] - reverse domain
	# $argv[4] - underscore domain

	# For readability, set $argv parts to discrete variables
	set domain $argv[1]
	set template_index $argv[2]
	set reverse_domain $argv[3]
	set underscore_domain $argv[4]

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
		s|{{GENERATION_DATE}}|$GENERATION_DATE|g" $template_file > $vhosts_file

	# Check if SSL folder exists
	if not test -d $PROVISION_SSL
		handle_error "SSL folder $PROVISION_SSL not found"
	end

	# Set paths for SSL certificate and key
	set ssl_cert_file $PROVISION_SSL/$domain.cert
	set ssl_key_file $PROVISION_SSL/$domain.key

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
	sudo cp -f $PROVISION_SSL/$domain.* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p $VM_FOLDER/$underscore_domain

	# Copy files only if they do not exist
	set files_to_copy "index.html" "phpinfo.php" "db.php"
	for file in $files_to_copy
		cp -u $PROVISION_HTML/$file $VM_FOLDER/$underscore_domain/
	end


	# Enable site
	#sudo a2ensite $underscore_domain
end

# Iterate through the site data
for one_site in $sites
	# First get thy data in order young coder
	set site_info (string split ' ' $one_site)
	set parts (string split '.' $site_info[1])

	set reversed_parts ""
	for i in (seq (count $parts) -1 2)
		set -l part $parts[$i]
		set reversed_parts $reversed_parts$part"."
	end
	set reversed_parts $reversed_parts$parts[1]

	set parts (string split '.' $reversed_parts)

	set site_info $site_info (string join "." $parts)
	set site_info $site_info (string join "_" $parts)

	# Now go configure some web sites
	configure_sites $site_info
end

# Restart Apache after all configurations
#sudo service apache2 restart

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
