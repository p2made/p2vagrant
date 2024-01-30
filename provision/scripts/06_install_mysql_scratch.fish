#!/bin/fish

# 06 Install MySQL

# This script is intended for use with Vagrant provisioning.
# It installs MySQL, updates its configuration, creates a user and databases,
# and performs necessary configurations for integration with Apache.

# Usage in Vagrantfile:
#   config.vm.provision :shell, path: "provision/scripts/06_install_mysql.fish",
#                       args: [MYSQL_VERSION, PHP_VERSION, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

# Test usage:
#   sudo ./06_install_mysql.fish

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing MySQL 🚀"
echo "🇺🇿    📜 Script Name:  06_install_mysql.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-30"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - MYSQL_VERSION   = "8.1"
# 2 - PHP_VERSION     = "8.3"
# 3 - ROOT_PASSWORD   = ⚠️ See Vagrantfile
# 4 - DB_USERNAME     = ⚠️ See Vagrantfile
# 5 - DB_PASSWORD     = ⚠️ See Vagrantfile
# 6 - DB_NAME         = "example_db"
# 7 - DB_NAME_TEST    = "example_db_test"

set MYSQL_VERSION "8.1"             # test
set PHP_VERSION   "8.3"             # test
set ROOT_PASSWORD "RootPassw0rd"    # test
set DB_USERNAME   "fredspotty"      # test
set DB_PASSWORD   "Passw0rd"        # test
set DB_NAME       "example_db"      # test
set DB_NAME_TEST  "example_db_test" # test

set MYSQL_VERSION $argv[1]
set PHP_VERSION   $argv[2]
set ROOT_PASSWORD $argv[3]
set DB_USERNAME   $argv[4]
set DB_PASSWORD   $argv[5]
set DB_NAME       $argv[6]
set DB_NAME_TEST  $argv[7]

echo "MYSQL_VERSION: $MYSQL_VERSION"
echo "PHP_VERSION:   $PHP_VERSION"
echo "ROOT_PASSWORD: $DB_USERNAME"
echo "DB_USERNAME:   $DB_USERNAME"
echo "DB_PASSWORD:   $DB_PASSWORD"
echo "DB_NAME:       $DB_NAME"
echo "DB_NAME_TEST:  $DB_NAME_TEST"

set PACKAGE_LIST \
    mysql-server \
    mysql-client \
    mysql-utilities

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

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

sudo mkdir -p /var/www/provision/logs
sudo touch /var/www/provision/logs/mysql_output.log
sudo chmod -R 755 /var/www/provision/logs

# Set root password
mysqladmin -u root password $ROOT_PASSWORD || handle_error "Failed to set root password."

# Create the database and grant privileges
set -a sql_string (echo "CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD'")
set -a err_string (echo "Failed to create MySQL user")
set -a sql_string (echo "CREATE DATABASE IF NOT EXISTS $DB_NAME")
set -a err_string (echo "Failed to create MySQL database $DB_NAME")
set -a sql_string (echo "CREATE DATABASE IF NOT EXISTS $DB_NAME_TEST")
set -a err_string (echo "Failed to create MySQL database $DB_NAME_TEST")
set -a sql_string (echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';")
set -a err_string (echo "Failed to grant privileges on $DB_NAME")
set -a sql_string (echo "GRANT ALL PRIVILEGES ON $DB_NAME_TEST.* TO '$DB_USERNAME'@'%';")
set -a err_string (echo "Failed to grant privileges on $DB_NAME_TEST")
set -a sql_string (echo "flush privileges")
set -a err_string (echo "Failed to flush privileges")

for i in (seq 1 6)
    echo $sql_string[$i] | mysql -u root -p$ROOT_PASSWORD > /var/www/provision/logs/mysql_output.log 2>&1 || \
        handle_error $err_string[$i]
end

# Update MySQL configuration
if test -f /etc/mysql/mysql.conf.d/mysqld.cnf
    sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
else
    handle_error "mysqld.cnf file not found."
end

# Copy database file
cp /var/www/provision/html/db.php /var/www/html/ || \
    handle_error "Failed to copy db.php file"

# Set permissions
sudo chmod -R 755 /var/www/html/ || \
    handle_error "Failed to set permissions on /var/www/html/"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 MySQL Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
