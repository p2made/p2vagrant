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

# Function to configure a website
# Usage: configure_website $site_info
function configure_website
	# Put `conf` & SSL files into place
	sudo cp -f $PROVISION_VHOSTS/$argv[3] /etc/apache2/sites-available/
	sudo cp -f $PROVISION_SSL/$argv[5]_$TODAYS_DATE.* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p $VM_FOLDER/$underscore_domain

	# Copy files only if they do not exist
	set files_to_copy "index.html" "index.php" "phpinfo.php" "db.php"
	for file in $files_to_copy
		cp -u $PROVISION_HTML/$file $VM_FOLDER/$argv[5]/
	end

	# Enable site
	sudo a2ensite $argv[3]
end

# Function to setup important site variables
# We can't return a value, so we put them in a global variable
# that we will quickly use & then erase.
# Usage: setup_site_variables $one_site
function setup_site_variables
	# Use the passed string $one_site to set...
	# $site_info_temp[1-6], where...
	# $site_info_temp[1] is the domain
	# $site_info_temp[2] is the reverse domain
	# $site_info_temp[3] is the underscore domain
	# $site_info_temp[4] is the template filename
	# $site_info_temp[5] is the vhosts filename
	# $site_info_temp[6] is the SSL filename

	set split_temp (string split ' ' $argv)

	set -g site_info_temp[1] $split_temp[1]                            # 1 domain name

	set parts (string split '.' $split_temp[1])

	for part in $parts
		set -p reversed $part
	end

	set -g site_info_temp[2] (string join "." $reversed)               # 2 reverse domain
	set -g site_info_temp[3] (string join "_" $reversed)               # 3 underscore domain

	set -g site_info_temp[4] $split_temp[2].conf                       # 4 template filename

	if set -q split_temp[3]
		set -g site_info_temp[5] $split_temp[3]_
	else
		set -g site_info_temp[5] ""
	end

	set -g site_info_temp[5] $site_info_temp[5]$site_info_temp[3].conf # 5 vhosts filename
	set -g site_info_temp[6] $site_info_temp[3]_$TODAYS_DATE           # 6 SSL base filename
end

# Function to write the vhosts file from a template
# Usage: write_vhosts_file $site_info
function write_vhosts_file
	# Check if the template file exists
	if not test -f $PROVISION_TEMPLATES/$argv[4]
		handle_error "Template file $template_filename.conf not found in $PROVISION_TEMPLATES"
	end

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		-e "s|{{DOMAIN}}|$argv[1]|g" \
		-e "s|{{UNDERSCORE_DOMAIN}}|$argv[3]|g" \
		-e "s|{{SSL_FILENAME}}|$argv[6]|g" \
		-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
		$PROVISION_TEMPLATES/$argv[4] > $PROVISION_VHOSTS/$argv[5]
end

# Function to generate SSL files
# Usage: generate_ssl_files $site_info
function generate_ssl_files
	# Check if SSL folder exists
	if not test -d $PROVISION_SSL
		handle_error "SSL folder $PROVISION_SSL not found"
	end

	# Generate SSL key
	openssl genrsa \
		-out $PROVISION_SSL/$argv[6].key \
		2048

	# Generate self-signed SSL certificate
	openssl req -new -x509 \
		-key $PROVISION_SSL/$argv[6].key \
		-out $PROVISION_SSL/$argv[6].cert \
		-days 3650 \
		-subj /CN=$argv[1]
end

for one_site in (cat $site_data_file | grep -v '^#')
	# First get thy data in order, young coder
	setup_site_variables $one_site

	# We have the data all as we want it, but in a global variable
	# Put it in a local variable, & erase the global variable
	set site_info $site_info_temp
	set -e site_info_temp

	# site_info[1] - domain
	# site_info[2] - reverse_domain
	# site_info[3] - underscore_domain
	# site_info[4] - template_filename
	# site_info[5] - vhosts_filename
	# site_info[6] - ssl_filename

	# Now all the data for a site is in `site_info`
	# Within functions, replace 'site_info' with 'argv'

	# Now go configure some web sites
	write_vhosts_file  $site_info
	generate_ssl_files $site_info

end

# Restart Apache after all configurations
sudo service apache2 restart

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete

	#echo "site_info[1] $site_info[1]"
	#echo "site_info[2] $site_info[2]"
	#echo "site_info[3] $site_info[3]"
	#echo "site_info[4] $site_info[4]"
	#echo "site_info[5] $site_info[5]"
	#echo "site_info[6] $site_info[6]"
