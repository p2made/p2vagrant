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

# -- -- // -- -- // -- -- // -- -- // -- -- // -- --

--------------------------------------------------------------------------------
configure_sites_0.sh:
#!/bin/sh

# 11 Configure Websites

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🌍 Configuring Websites 🌍"
echo "📜 Script Name:  configure_sites.sh"
echo "📅 Last Updated: 2024-01-21"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

# Variables...
# 1 - REMOTE_FOLDER   = "/var/www"

VM_FOLDER="$1"
TEMPLATES_FOLDER="${VM_FOLDER}/provision/templates"
VHOSTS_FOLDER="${VM_FOLDER}/provision/vhosts"
SSL_FOLDER="${VM_FOLDER}/provision/ssl"
GENERATION_DATE=$(date "+%Y-%m-%d")

# Array of site data
echo "📚 About to attempt reading data."
sites=(
    "subdomain1.example.tld|tld.example.subdomain1|tld_example_subdomain1|0"
    "subdomain2.example.tld|tld.example.subdomain2|tld_example_subdomain2|0"
    "example.tld|tld.example|tld_example|1"
)
echo "✅ Data read in successfully."

# Load site data from the data file
#DATA_FILE="${VM_FOLDER}/provision/data/sites_data"
#if [ ! -f "$DATA_FILE" ]; then
#	echo "⚠️ Error: Data file $DATA_FILE not found."
#	exit 1
#fi
#set -l sites (cat "$DATA_FILE" | tr "\n" " ")

# Function for error handling
handle_error() {
	echo "⚠️ Error: $1 💥"
	exit 1
}

# Function to generate the conf files
generate_conf() {
	local domain=$1
	local reverse_domain=$2
	local transformed_domain=$3
	local numeric_template=$4

	# Select the appropriate template based on the numeric value
	local template_file="${TEMPLATES_FOLDER}/${numeric_template}.conf"

	# Check if the template file exists
	if [ ! -f "$template_file" ]; then
		handle_error "Template file ${numeric_template}.conf not found in ${TEMPLATES_FOLDER}."
	fi

	# Read the template content
	local template_content=$(cat "$template_file")

	# Replace placeholders with actual values
	local content_with_placeholders=$(echo "$template_content" | \
		sed "s|{{DOMAIN}}|${domain}|g" | \
		sed "s|{{TRANSFORMED_DOMAIN}}|${transformed_domain}|g" | \
		sed "s|{{REVERSE_DOMAIN}}|${reverse_domain}|g" | \
		sed "s|{{GENERATION_DATE}}|${GENERATION_DATE}|g"
	)

	# Save conf file
	echo "${content_with_placeholders}" >"${VHOSTS_FOLDER}/${transformed_domain}.conf"

	# Check if the web root folder exists; if not, create it
	if [ ! -d "${VM_FOLDER}/${transformed_domain}" ]; then
		mkdir "${VM_FOLDER}/${transformed_domain}"
	fi

	# Copy index.html if it doesn't exist in the web root folder
	if [ ! -f "${VM_FOLDER}/${transformed_domain}/index.html" ]; then
		cp "${VM_FOLDER}/provision/html/index.html" "${VM_FOLDER}/${transformed_domain}/"
	fi

	# Copy phpinfo.php if it doesn't exist in the web root folder
	if [ ! -f "${VM_FOLDER}/${transformed_domain}/phpinfo.php" ]; then
		cp "${VM_FOLDER}/provision/html/phpinfo.php" "${VM_FOLDER}/${transformed_domain}/"
	fi

	echo ""
	echo "✅ ${transformed_domain}.conf configured successfully!"
	echo ""
}

# Loop through each site and generate conf files
for site_data in "${sites[@]}"; do
	IFS='|' read -r -a site_data <<< "${site_data}"
	generate_conf "${site_data[0]}" "${site_data[1]}" "${site_data[2]}" "${site_data[3]}"
done

# Iterate through the site data
for site_info in "${sites[@]}"
do
    # Split the line into individual pieces
    domain=$(echo "$site_info" | awk '{print $1}')
    transformed_domain=$(echo "$site_info" | awk '{print $2}')
    numeric_template=$(echo "$site_info" | awk '{print $3}')

    echo "✅ Line $argv[5] read in successfully."

    # Call the function to generate conf and SSL files
    generate_files "$domain" "$transformed_domain" "$numeric_template"
done

# Iterate through the site data
for site_info in $sites
do
	echo "✅ Line."
done



service apache2 restart

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 Websites Configured ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"





# -- -- // -- -- // -- -- // -- -- // -- -- // -- --








--------------------------------------------------------------------------------
configure_sites_1.sh:
#!/bin/sh

# 11 Configure Websites

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🌍 Configuring Websites 🌍"
echo "📜 Script Name:  configure_sites.sh"
echo "📅 Last Updated: 2024-01-21"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

# Variables...
VM_FOLDER="$1"
TEMPLATES_FOLDER="${VM_FOLDER}/provision/templates"
VHOSTS_FOLDER="${VM_FOLDER}/provision/vhosts"
SSL_FOLDER="${VM_FOLDER}/provision/ssl"
GENERATION_DATE=$(date "+%Y-%m-%d")

# Array of site data
echo "📚 About to attempt reading data."
set sites \
    "subdomain1.example.tld tld.example.subdomain1 tld_example_subdomain1 0" \
    "subdomain2.example.tld tld.example.subdomain2 tld_example_subdomain2 0" \
    "example.tld tld.example tld_example 1"
echo "✅ Data read in successfully."

# Function for error handling
handle_error() {
    echo "⚠️ Error: $1 💥"
    exit 1
}

export DEBIAN_FRONTEND=noninteractive

# Function to generate the conf files and SSL files
generate_files() {
    local domain=$1
    local reverse_domain=$2
    local transformed_domain=$3
    local numeric_template=$4

    # Select the appropriate template based on the numeric value
    local template_file="${TEMPLATES_FOLDER}/${numeric_template}.conf"

    # Check if the template file exists
    if [ ! -f "$template_file" ]; then
        handle_error "Template file ${numeric_template}.conf not found in ${TEMPLATES_FOLDER}."
    fi

    # Read the template content
    local template_content=$(cat "$template_file")

    # Replace placeholders with actual values
    local content_with_placeholders=$(echo "$template_content" | \
        sed "s|{{DOMAIN}}|${domain}|g" | \
        sed "s|{{TRANSFORMED_DOMAIN}}|${transformed_domain}|g" | \
        sed "s|{{REVERSE_DOMAIN}}|${reverse_domain}|g" | \
        sed "s|{{GENERATION_DATE}}|${GENERATION_DATE}|g"
    )

    # Save conf file
    echo "${content_with_placeholders}" >"${VHOSTS_FOLDER}/${transformed_domain}.conf"

    # Check if the SSL folder exists; if not, create it
    if [ ! -d "${SSL_FOLDER}" ]; then
        mkdir "${SSL_FOLDER}"
    fi

    # Generate SSL files (dummy command, replace with actual SSL generation)
    echo "Generating SSL files for ${transformed_domain} in ${SSL_FOLDER}"

    # Move generated SSL files to SSL folder
    # (dummy command, replace with actual file moving)
    mv "${VHOSTS_FOLDER}/${transformed_domain}.key" "${SSL_FOLDER}/"
    mv "${VHOSTS_FOLDER}/${transformed_domain}.crt" "${SSL_FOLDER}/"

    echo ""
    echo "✅ ${transformed_domain}.conf and SSL files generated successfully!"
    echo ""
}

# Iterate through the site data
for site_info in $sites
do
    # Split the line into individual pieces
    domain=$(echo "$site_info" | awk '{print $1}')
    transformed_domain=$(echo "$site_info" | awk '{print $2}')
    numeric_template=$(echo "$site_info" | awk '{print $3}')

    echo "✅ Line read in successfully."

    # Call the function to generate conf and SSL files
    generate_files "$domain" "$transformed_domain" "$numeric_template"
done

# Restart Apache after all configurations
#service apache2 restart

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 Websites Configured ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"

# -- -- // -- -- // -- -- // -- -- // -- -- // -- --

--------------------------------------------------------------------------------
configure_sites_2.sh:
#!/usr/bin/env fish

# 11 Configure Websites

echo -e "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo -e ""

# Variables...
# 1 - REMOTE_FOLDER   = "/var/www"
#set VM_FOLDER $1
set VM_FOLDER "/var/www"
set TEMPLATES_FOLDER $VM_FOLDER/provision/templates
set VHOSTS_FOLDER $VM_FOLDER/provision/vhosts
set SSL_FOLDER $VM_FOLDER/provision/ssl
set GENERATION_DATE $(date "+%Y-%m-%d")

# Array of site data
echo -e "📚 About to attempt reading data."
set sites \
	"subdomain1.example.tld 0" \
	"subdomain2.example.tld 0" \
	"example.tld 1"
echo -e "✅ Data read in successfully."

# Function for error handling
function handle_error
	echo -e "⚠️ Error: $argv 💥"
	exit 1
end

# Function to reverse a domain and transform it
function reverse_and_transform_domain
#	Correct output for `subdomain.example.tld` should be...
#		reversed: tld.example.subdomain
#		transformed: tld_example_subdomain
#
#	Expected return is...
#		tld.example.subdomain tld_example_subdomain
#

	echo "Correct output for `subdomain.example.tld` should be..."
	echo "reversed: tld.example.subdomain"
	echo "transformed: tld_example_subdomain"
	echo ""
	echo "Expected return is..."
	echo "tld.example.subdomain tld_example_subdomain"
	echo ""

	set domain $argv[1]
	set parts (string split '.' $domain)

	set reversed_parts ""
	for i in (seq (count $parts) -1 1)
		set -l part $parts[$i]
		set reversed_parts $reversed_parts$part"."
	end
	set reversed_parts $reversed_parts$parts[1]

	set parts (string split '.' $reversed_parts)

    set reversed (string join "." $parts)
    set transformed (string join "_" $parts)

    # Output the values as an array
    echo $reversed $transformed
end

# Function to generate the conf files and SSL files
function generate_files
	set domain $argv[1]
	set template_index $argv[2]

	# get `reversed_and_transformed`
	set reversed_and_transformed (reverse_and_transform_domain "subdomain.example.tld")

	# Set explicit variables
	set reversed $reversed_and_transformed[1]
	set transformed $reversed_and_transformed[2]

	# Now we have as data...
	#   $domain         | as named
	#   $template_index | numeric part of template filename
	#   $reversed       | normal reverse domain format
	#   $transformed    | `$reversed` with '_' instead of '.'


	# Select the appropriate template based on the numeric value
	set template_file $TEMPLATES_FOLDER"/"$template_index".conf"

	# Check if the template file exists
	if not test -f "$template_file"
		handle_error "Template file $template_index.conf not found in $TEMPLATES_FOLDER."
	end

	# Read the template content
	set template_content (cat "$template_file")

	# Replace placeholders with actual values
	set content_with_placeholders (echo -e "$template_content" | \
		sed "s|{{DOMAIN}}|$domain|g" | \
		sed "s|{{TRANSFORMED_DOMAIN}}|$transformed_domain|g" | \
		sed "s|{{REVERSE_DOMAIN}}|$reverse_domain|g" | \
		sed "s|{{GENERATION_DATE}}|$GENERATION_DATE|g"
	)

	# Save conf file
	echo -e "$content_with_placeholders" >$VHOSTS_FOLDER/$transformed_domain.conf

	# Check if the SSL folder exists; if not, create it
	if not test -d "$SSL_FOLDER"
		mkdir "$SSL_FOLDER"
	end

	# Generate SSL files (dummy command, replace with actual SSL generation)
	echo "Generating SSL files for $transformed_domain in $SSL_FOLDER"

	# Move generated SSL files to SSL folder
	# (dummy command, replace with actual file moving)
	mv $VHOSTS_FOLDER/$transformed_domain.key "$SSL_FOLDER/"
	mv $VHOSTS_FOLDER/$transformed_domain.crt "$SSL_FOLDER/"

	# Use the values as needed
	echo "Reversed: $reversed"
	echo "Transformed: $transformed"

	echo ""
	echo "✅ $transformed_domain.conf and SSL files generated successfully!"
	echo ""
end


# Iterate through the site data
for site_info in $sites
	# Call the function to generate conf and SSL files
	generate_files $site_info
end

# Restart Apache after all configurations
#service apache2 restart

echo -e ""
echo -e "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"

# -- -- // -- -- // -- -- // -- -- // -- -- // -- --

--------------------------------------------------------------------------------
configure_sites_3.sh:
#!/usr/bin/env fish

# 11 Configure Websites

echo -e "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo -e ""

# Variables...
# 1 - REMOTE_FOLDER   = "/var/www"
#set VM_FOLDER $1
set VM_FOLDER "/var/www"
set TEMPLATES_FOLDER $VM_FOLDER/provision/templates
set VHOSTS_FOLDER $VM_FOLDER/provision/vhosts
set SSL_FOLDER $VM_FOLDER/provision/ssl
set GENERATION_DATE $(date "+%Y-%m-%d")

# Array of site data
echo -e "📚 About to attempt reading data."
set sites \
	"subdomain1.example.tld 0" \
	"subdomain2.example.tld 0" \
	"example.tld 1"
echo -e "✅ Data read in successfully."

# Function for error handling
function handle_error
	echo -e "⚠️ Error: $argv 💥"
	exit 1
end

# Function to generate the conf files and SSL files
function configure_sites
	set site_info (string split ' ' $argv)

	# First get thy data in order young coder
	set domain $site_info[1]
	set template_index $site_info[2]

	set parts (string split '.' $domain)

	set reversed_parts ""
	for i in (seq (count $parts) -1 2)
		set -l part $parts[$i]
		set reversed_parts $reversed_parts$part"."
	end
	set reversed_parts $reversed_parts$parts[1]

	set parts (string split '.' $reversed_parts)

	set reversed (string join "." $parts)
	set transformed (string join "_" $parts)

	# Select the appropriate template based on the numeric value
	set template_file $TEMPLATES_FOLDER"/"$template_index".conf"

	# Check if the template file exists
	if not test -f "$template_file"
		handle_error "Template file $template_index.conf not found in $TEMPLATES_FOLDER."
	end

	# Read the template content
	set conf_template (cat "$template_file")

	# Replace placeholders with actual values
	set content_with_data (echo "$conf_template" | \
		sed "s|{{DOMAIN}}|$domain|g" | \
		sed "s|{{TRANSFORMED_DOMAIN}}|$transformed_domain|g" | \
		sed "s|{{REVERSE_DOMAIN}}|$reverse_domain|g" | \
		sed "s|{{GENERATION_DATE}}|$GENERATION_DATE|g"
	)

	# Save conf file
	set conf_file_path $VHOSTS_FOLDER"/"$transformed_domain".conf"
	echo $conf_file_path
	echo $content_with_data > $conf_file_path

	echo -e ""
	echo -e "✅ Stuff done! ... we freakin' hope 😖"
	echo -e ""
end

# Iterate through the site data
for site_info in $sites
	echo -e "⭐ ¡Oi! I've just arrived in the \$site_info loop 🛩️"
	# Call the function to generate conf and SSL files

	echo -e "You wanted to know the data we're working with?"
	echo -e "It's \$site_info"

	configure_sites $site_info
end

# Restart Apache after all configurations
#service apache2 restart

echo -e ""
echo -e "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"

# -- -- // -- -- // -- -- // -- -- // -- -- // -- --

--------------------------------------------------------------------------------
configure_sites_4.sh:
#!/usr/bin/env fish

# 11 Configure Websites

echo -e "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo -e ""

# Variables...
# 1 - REMOTE_FOLDER   = "/var/www"
#set VM_FOLDER $1
set VM_FOLDER "/var/www"
set DATA_FOLDER $VM_FOLDER/provision/data
set TEMPLATES_FOLDER $VM_FOLDER/provision/templates
set VHOSTS_FOLDER $VM_FOLDER/provision/vhosts
set SSL_FOLDER $VM_FOLDER/provision/ssl
set GENERATION_DATE $(date "+%Y-%m-%d")

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

# -- -- // -- -- // -- -- // -- -- // -- -- // -- --

