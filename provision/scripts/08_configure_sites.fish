#!/bin/fish

# 00 _script_title_

echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
echo "🇺🇦"
echo "🇺🇦    🚀 Configuring Websites 🚀"
echo "🇺🇦    📜 Script Name:  08_configure_sites.fish"
echo "🇺🇦    📅 Last Updated: 2024-01-28"
echo "🇺🇦"
echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳"
echo ""
# -- -- /%/ -- -- /%/ -- header_banner -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - REMOTE_FOLDER   = "/var/www"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# Function for error handling
# Usage: handle_error "Error message"

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]

# Function to update package lists
# Usage: update_package_lists

# Function to install packages with error handling
# Usage: install_packages $package_list

# Script variables...

# Function to set path variables based on the passed path root
# Usage: set_path_variables /var/www - usually REMOTE_FOLDER from the Vagrantfile
# VM_FOLDER $argv[1]
# PROVISION_FOLDER $VM_FOLDER/provision
# DATA_FOLDER      $PROVISION_FOLDER/data
# HTML_FOLDER      $PROVISION_FOLDER/html
# LOGS_FOLDER      $PROVISION_FOLDER/logs
# SCRIPTS_FOLDER   $PROVISION_FOLDER/scripts
# SSL_FOLDER       $PROVISION_FOLDER/ssl
# TEMPLATES_FOLDER $PROVISION_FOLDER/templates
# VHOSTS_FOLDER    $PROVISION_FOLDER/vhosts
set_path_variables $argv[1]

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	package1 \
	package2

set -x DEBIAN_FRONTEND noninteractive

# Start _script_title_ logic...

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
# Functions

# Function form
#function function_name
#    ... Function body ...
#    if not [SOME_CHECK]
#        handle_error "Failed to perform some action."
#    end
#    announce_success "Successfully completed some action." # optional
#end

# Example usage:
#function_name
#function_name argument
#function_name argument1 argument2

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
# Execution

# Add repository if appliciable

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

# single line statements
# including calls to functions

# -- -- /%/ -- -- /%/ -- footer_banner -- /%/ -- -- /%/ -- --
echo ""
echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
echo "🇺🇦"
echo "🇺🇦    🏆 _script_job_complete_ ‼️"
echo "🇺🇦"
echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --


#set VM_FOLDER           $1            # production version
set VM_FOLDER           "/var/www"    # ssh test version
set PROVISION_FOLDER    $VM_FOLDER/provision
set DATA_FOLDER         $PROVISION_FOLDER/data
set HTML_FOLDER         $PROVISION_FOLDER/html
set SSL_FOLDER          $PROVISION_FOLDER/ssl
set TEMPLATES_FOLDER    $PROVISION_FOLDER/templates
set VHOSTS_FOLDER       $PROVISION_FOLDER/vhosts
set GENERATION_DATE     $(date "+%Y-%m-%d")

# Array of site data
set sites \
	"example.tld 1" \
	"subdomain1.example.tld 0" \
	"subdomain2.example.tld 0"

# Function for error handling
function handle_error
	echo "⚠️ Error: $argv 💥"
	exit 1
end

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
	set template_file $TEMPLATES_FOLDER/$template_index.conf
	set vhosts_file $VHOSTS_FOLDER/$underscore_domain.conf

	# Check if the template file exists
	if not test -f $template_file
		handle_error "Template file $template_index.conf not found in $TEMPLATES_FOLDER"
	end

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		"s|{{DOMAIN}}|$domain|g; \
		s|{{UNDERSCORE_DOMAIN}}|$underscore_domain|g; \
		s|{{GENERATION_DATE}}|$GENERATION_DATE|g" $template_file > $vhosts_file

	# Check if SSL folder exists
	if not test -d $SSL_FOLDER
		handle_error "SSL folder $SSL_FOLDER not found"
	end

	# Set paths for SSL certificate and key
	set ssl_cert_file $SSL_FOLDER/$domain.cert
	set ssl_key_file $SSL_FOLDER/$domain.key

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
	sudo cp -f $SSL_FOLDER/$domain.* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p $VM_FOLDER/$underscore_domain

	# Copy files only if they do not exist
	set files_to_copy "index.html" "phpinfo.php" "db.php"
	for file in $files_to_copy
		cp -u $HTML_FOLDER/$file $VM_FOLDER/$underscore_domain/
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

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿 🏆 Websites Configured ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
