#!/bin/bash

# _sites.sh
# Updated: 2024-02-14

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/         Sites Configuration         /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to setup important site variables
# We can't return a value, so we put them in a global
# variable that we will quickly use & then erase.
# Usage: setup_site_variables $one_site
function setup_site_variables () {
	# Use the passed string $one_site to set a temporary global...
	# $site_info_temp[1-6], where...
	# $site_info_temp[1] is the domain
	# $site_info_temp[2] is the reverse domain
	# $site_info_temp[3] is the underscore domain
	# $site_info_temp[4] is the template filename
	# $site_info_temp[5] is the vhosts filename
	# $site_info_temp[6] is the SSL filename

}

# Function to write the vhosts file from a template
# Usage: write_vhosts_file $domain $underscore_domain $template_filename $vhosts_filename $ssl_base_filename
function write_vhosts_file () {
}

# Function to generate SSL files
# Usage: generate_ssl_files $domain $ssl_base_filename
function generate_ssl_files () {
}

# Function to configure a website with everything done so far
# Usage: configure_website $domain $underscore_domain $vhosts_filename $ssl_base_filename
function configure_website () {
}

# Example usage:
# one_site="example.com templatefile outputfile"
# setup_site_variables "$one_site"
# write_vhosts_file "${site_info_temp[@]}"
# generate_ssl_files "${site_info_temp[@]}"
# configure_website "${site_info_temp[@]}"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

