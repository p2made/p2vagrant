#!/bin/fish

# 06 Install MySQL

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

# Arguments...
# 1 - MYSQL_VERSION   = "8.1"
# 2 - DB_USERNAME     = "fredspotty"
# 3 - DB_PASSWORD     = "Passw0rd"
# 4 - DB_NAME         = "example_db"
# 5 - DB_NAME_TEST    = "example_db_test"
# 6 - PHP_VERSION     = "8.3"

set MYSQL_VERSION "8.1"             # test
set DB_USERNAME "fredspotty"        # test
set DB_PASSWORD "Passw0rd"          # test
set DB_NAME "example_db"            # test
set DB_NAME_TEST "example_db_test"  # test
set PHP_VERSION "8.3"               # test

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

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Create the database and grant privileges
set sql_string (echo "CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD'")
set err_string (echo "Failed to create MySQL user")
echo "sql_string: $sql_string"
echo "err_string: $err_string"

set sql_string (echo "CREATE DATABASE IF NOT EXISTS $DB_NAME")
set err_string (echo "Failed to create MySQL database $DB_NAME")
echo "sql_string: $sql_string"
echo "err_string: $err_string"

set sql_string (echo "CREATE DATABASE IF NOT EXISTS $DB_NAME_TEST")
set err_string (echo "Failed to create MySQL database $DB_NAME_TEST")
echo "sql_string: $sql_string"
echo "err_string: $err_string"

set sql_string (echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';")
set err_string (echo "Failed to grant privileges on $DB_NAME")
echo "sql_string: $sql_string"
echo "err_string: $err_string"

set sql_string (echo "GRANT ALL PRIVILEGES ON $DB_NAME_TEST.* TO '$DB_USERNAME'@'%';")
set err_string (echo "Failed to grant privileges on $DB_NAME_TEST")
echo "sql_string: $sql_string"
echo "err_string: $err_string"

set sql_string (echo "flush privileges")
set err_string (echo "Failed to flush privileges")
echo "sql_string: $sql_string"
echo "err_string: $err_string"

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 MySQL Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
