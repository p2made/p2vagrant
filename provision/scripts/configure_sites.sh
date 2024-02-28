#!/bin/bash

# 09 Configure Sites

script_name="configure_sites.sh"
updated_date="2024-02-26"

active_title="Configuring Websites"
job_complete="Websites Configured"

# Source common functions
source /var/www/provision/scripts/_common.sh
source /var/www/provision/scripts/_sites.sh

# Arguments...
# NONE!

# Script variables...
# NONE!

# File path for site data
site_data_file="$PROVISION_DATA/sites_data"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to loop through sites data & configure individual websites
# Usage: configure_websites
function configure_websites() {
	while IFS= read -r one_site; do
		# Skip lines starting with #
		[[ $one_site =~ ^# ]] && continue

		# First get thy data in order, young coder
		debug_message "$LINENO" "\$one_site is $one_site"
		setup_site_variables $one_site

		# We have the data all as we want it, but in a global variable
		# Put it in local variables, & erase the global variable
		local domain="${site_info_temp[1]}"
		local reverse_domain="${site_info_temp[2]}"
		local underscore_domain="${site_info_temp[3]}"
		local template_filename="${site_info_temp[4]}"
		local vhosts_filename="${site_info_temp[5]}"
		local ssl_base_filename="${site_info_temp[6]}"

		unset site_info_temp

		# Output progress message
		echo "Data for $one_site..."
		echo "\$domain            $domain"
		echo "\$reverse_domain    $reverse_domain"
		echo "\$underscore_domain $underscore_domain"
		echo "\$template_filename $template_filename"
		echo "\$vhosts_filename   $vhosts_filename"
		echo "\$ssl_base_filename $ssl_base_filename"

		# Now go configure some web sites
		generate_vhosts_file \
			"$domain" \
			"$underscore_domain" \
			"$template_filename" \
			"$vhosts_filename" \
			"$ssl_base_filename"
		generate_ssl_files \
			"$domain" \
			"$ssl_base_filename"
		configure_website \
			"$domain" \
			"$underscore_domain" \
			"$vhosts_filename" \
			"$ssl_base_filename"
	done < "$site_data_file"

	# Restart Apache after all configurations
	echo "Restarting apache to enable new websites."
	sudo service apache2 restart
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function provision() {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date" false

	export DEBIAN_FRONTEND=noninteractive

	configure_websites

	# Footer banner
	footer_banner "$job_complete"
}

provision

# debug_message "$LINENO" "Message"
