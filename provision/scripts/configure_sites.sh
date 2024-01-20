#!/bin/sh

# 10 Configure Websites

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

# Load site data from the data file
DATA_FILE="${VM_FOLDER}/provision/data/sites_data.txt"
if [ ! -f "$DATA_FILE" ]; then
	echo "⚠️ Error: Data file $DATA_FILE not found."
	exit 1
fi
sites=($(cat "$DATA_FILE"))

# Function for error handling
handle_error() {
	echo "⚠️ Error: $1 💥"
	exit 1
}

export DEBIAN_FRONTEND=noninteractive

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
	IFS='|' read -ra site_data <<<"${site_data}"
	generate_conf "${site_data[0]}" "${site_data[1]}" "${site_data[2]}" "${site_data[3]}"
done

service apache2 restart

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 Websites Configured ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
