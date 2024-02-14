#!/bin/fish

# 09 Configure Sites

set script_name     "configure_sites.fish"
set updated_date    "2024-02-12"

set active_title    "Configuring Websites"
set job_complete    "Websites Configured"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh

# Arguments...
# NONE!"

# Script variables...
# NONE!"

# File path for site data
set site_data_file "/var/www/provision/data/sites_data"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to loop through sites data & configure individual websites
# Usage: onfigure_websites
function onfigure_websites
	for one_site in (cat $site_data_file | grep -v '^#')
		# First get thy data in order, young coder
		setup_site_variables $one_site

		# We have the data all as we want it, but in a global variable
		# Put it in local variables, & erase the global variable
		set domain            $site_info_temp[1]
		set reverse_domain    $site_info_temp[2]
		set underscore_domain $site_info_temp[3]
		set template_filename $site_info_temp[4]
		set vhosts_filename   $site_info_temp[5]
		set ssl_base_filename $site_info_temp[6]

		set -e site_info_temp

		# Output progress message
		echo "Data for $one_site..."
		echo "\$domain            $domain"
		echo "\$reverse_domain    $reverse_domain"
		echo "\$underscore_domain $underscore_domain"
		echo "\$template_filename $template_filename"
		echo "\$vhosts_filename   $vhosts_filename"
		echo "\$ssl_base_filename $ssl_base_filename"

		# Now go configure some web sites
		write_vhosts_file \
			$domain \
			$underscore_domain \
			$template_filename \
			$vhosts_filename \
			$ssl_base_filename
		generate_ssl_files \
			$domain \
			$ssl_base_filename
		configure_website \
			$domain \
			$underscore_domain \
			$vhosts_filename \
			$ssl_base_filename

		# $domain $reverse_domain $underscore_domain $template_filename $vhosts_filename $ssl_base_filename
	end

	# Restart Apache after all configurations
	echo "Restarting apache to enable new websites."
	sudo service apache2 restart
	announce_success "Websites setup complete."
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function provision
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	set -x DEBIAN_FRONTEND noninteractive

	onfigure_websites

	# Footer banner
	footer_banner "$job_complete"
end

provision
