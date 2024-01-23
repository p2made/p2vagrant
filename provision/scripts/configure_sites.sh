#!/usr/bin/env fish

# 11 Configure Websites

echo -e "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo -e ""

# Variables...
# 1 - REMOTE_FOLDER   = "/var/www"
#set VM_FOLDER           $1            # production version
set VM_FOLDER           "/var/www"    # ssh test version
set DATA_FOLDER         $VM_FOLDER/provision/data
set TEMPLATES_FOLDER    $VM_FOLDER/provision/templates
set VHOSTS_FOLDER       $VM_FOLDER/provision/vhosts
set SSL_FOLDER          $VM_FOLDER/provision/ssl
set GENERATION_DATE     $(date "+%Y-%m-%d")

# Array of site data
echo -e "📚 About to attempt reading data."

# Load site data from the data file
set DATA_FILE "$DATA_FOLDER/sites_data"
if [ ! -f "$DATA_FILE" ]; then
	echo "⚠️ Error: Data file $DATA_FILE not found."
	exit 1
end
set sites (cat "$DATA_FILE")

# Function for error handling
function handle_error
	echo -e "⚠️ Error: $argv 💥"
	exit 1
end

# Function to generate the conf files and SSL files
function configure_sites
	# $argv[1] - domain
	# $argv[2] - template index
	# $argv[3] - reversed domain
	# $argv[4] - transformed domain

	# Select the appropriate template based on the numeric value
	set template_file $TEMPLATES_FOLDER/$argv[2].conf

	# Check if the template file exists
	if not test -f $template_file
		handle_error "Template file $argv[2].conf not found in $TEMPLATES_FOLDER."
	end

	# Read the template content
	set conf_template (cat "$template_file")

	echo -e "conf_template: $conf_template"

	# Replace placeholders with actual values
	set content_with_data (echo $conf_template | \
		sed "s|{{DOMAIN}}|$argv[1]|g" | \
		sed "s|{{TRANSFORMED_DOMAIN}}|$argv[4]|g" | \
		sed "s|{{REVERSE_DOMAIN}}|$argv[3]|g" | \
		sed "s|{{GENERATION_DATE}}|$GENERATION_DATE|g"
	)

	echo -e "content_with_data: "$content_with_data

	# Save conf file
	set conf_file_path $VHOSTS_FOLDER"/"$argv[4]".conf"
	echo $content_with_data > $conf_file_path

	echo -e ""
	echo -e "✅ Stuff done! ... we freakin' hope 😖"
	echo -e ""
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
#service apache2 restart

echo -e ""
echo -e "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
