#!/bin/bash

# 07 Install MySQL

script_name="install_mysql.sh"
updated_date="2024-02-15"

active_title="Installing MySQL"
job_complete="MySQL Installed"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh

# Arguments...
MYSQL_VERSION=$1    # "8.0"
PHP_VERSION=$2      # "8.3"
ROOT_PASSWORD=$3    # ⚠️ See Vagrantfile
DB_USERNAME=$4      # ⚠️ See Vagrantfile
DB_PASSWORD=$5      # ⚠️ See Vagrantfile
DB_NAME=$6          # "example_db"
DB_NAME_TEST=$7     # "example_db_test"

# Script variables...
sql_string=(
	"CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD'"
	"CREATE DATABASE IF NOT EXISTS $DB_NAME"
	"CREATE DATABASE IF NOT EXISTS $DB_NAME_TEST"
	"GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%'"
	"GRANT ALL PRIVILEGES ON $DB_NAME_TEST.* TO '$DB_USERNAME'@'%'"
	"flush privileges"
)

#	"CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD'"
#	"CREATE DATABASE IF NOT EXISTS $DB_NAME"
#	"CREATE DATABASE IF NOT EXISTS $DB_NAME_TEST"
#	"GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';"
#	"GRANT ALL PRIVILEGES ON $DB_NAME_TEST.* TO '$DB_USERNAME'@'%';"
#	"flush privileges"

err_string=(
	"Failed to create MySQL user"
	"Failed to create MySQL database $DB_NAME"
	"Failed to create MySQL database $DB_NAME_TEST"
	"Failed to grant privileges on $DB_NAME"
	"Failed to grant privileges on $DB_NAME_TEST"
	"Failed to flush privileges"
)


# Always set package_list when using update_and_install_packages
package_list=(
	"mysql-server"
)

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to install MySQL
# Usage: install_mysql
function install_mysql() {
	# Update package lists & install packages
	update_package_lists
	install_packages "$package_list"

	# Set root password
	mysqladmin -u root password "$ROOT_PASSWORD" ||
		handle_error "Failed to set root password for MySQL."

	# Create the database and grant privileges
	for ((i = 0; i < ${#sql_string[@]}; i++)); do
		echo "${sql_string[i]}" | mysql -u root -p"$ROOT_PASSWORD" ||
			handle_error "${err_string[i]}"
	done

	# Update MySQL configuration
	if [[ -f /etc/mysql/mysql.conf.d/mysqld.cnf ]]; then
		sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
	else
		handle_error "mysqld.cnf file not found."
	fi
}

# Function to write db.php from a template
# Usage: generate_db_php
function generate_db_php() {
	local template_filename="db.php"

	# Check if the template file exists
	if [ ! -f "$PROVISION_TEMPLATES/$template_filename" ]; then
		handle_error "Template file $template_filename not found in $PROVISION_TEMPLATES"
	fi

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
		-e "s|{{VM_HOSTNAME}}|$VM_HOSTNAME|g" \
		-e "s|{{DB_USERNAME}}|$DB_USERNAME|g" \
		-e "s|{{DB_PASSWORD}}|$DB_PASSWORD|g" \
		-e "s|{{DB_NAME}}|$DB_NAME|g" \
		"$PROVISION_TEMPLATES/$template_filename" > "$PROVISION_HTML/$template_filename"

	cp "$PROVISION_HTML/db.php" "$SHARED_HTML/" ||
		handle_error "Failed to copy db.php file"

	# Set permissions
	sudo chmod -R 755 "$SHARED_HTML"/* ||
		handle_error "Failed to set permissions on $SHARED_HTML/"

	# Output progress message
	announce_success "Database test file created at $PROVISION_HTML/$template_filename"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function provision() {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	export DEBIAN_FRONTEND=noninteractive

	install_mysql
	generate_db_php

	# Footer banner
	footer_banner "$job_complete"
}

provision
