#!/bin/fish

# 06 Install MySQL

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing MySQL 🚀"
echo "🇺🇿    📜 Script Name:  06_install_mysql.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-28"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Variables...
# 1 - MYSQL_VERSION   = "8.1"
# 2 - DB_USERNAME     = "fredspotty"
# 3 - DB_PASSWORD     = "Passw0rd"
# 4 - DB_NAME         = "example_db"
# 5 - DB_NAME_TEST    = "example_db_test"
# 6 - PHP_VERSION     = "8.3"

#set MYSQL_VERSION $1                # prod
set MYSQL_VERSION "8.1"             # test
#set DB_USERNAME $2                  # prod
set DB_USERNAME "fredspotty"        # test
#set DB_PASSWORD $3                  # prod
set DB_PASSWORD "Passw0rd"          # test
#set DB_NAME $4                      # prod
set DB_NAME "example_db"            # test
#set DB_NAME_TEST $5                 # prod
set DB_NAME_TEST "example_db_test"  # test
#set PHP_VERSION $46                 # prod
set PHP_VERSION "8.3"               # test

set PACKAGE_LIST \
	mysql-server

# Source common functions
source /var/www/provision/scripts/common_functions.fish

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Update package lists
update_package_lists

# Install PHP packages
install_packages $PACKAGE_LIST

# Create the database and grant privileges
echo "CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD'" | \
	mysql || handle_error "Failed to create MySQL user"

echo "CREATE DATABASE IF NOT EXISTS $DB_NAME" | \
	mysql || handle_error "Failed to create MySQL database $DB_NAME"

echo "CREATE DATABASE IF NOT EXISTS $DB_NAME_TEST" | \
	mysql || handle_error "Failed to create MySQL database $DB_NAME_TEST"

echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';" | \
	mysql || handle_error "Failed to grant privileges on $DB_NAME"

echo "GRANT ALL PRIVILEGES ON $DB_NAME_TEST.* TO '$DB_USERNAME'@'%';" | \
	mysql || handle_error "Failed to grant privileges on $DB_NAME_TEST"

echo "flush privileges" | \
	mysql || handle_error "Failed to flush privileges"

# Update MySQL configuration
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Copy database file
cp /var/www/provision/html/db.php /var/www/html/ || handle_error "Failed to copy db.php file"

# Set permissions
sudo chmod -R 755 /var/www/html/ || handle_error "Failed to set permissions on /var/www/html/"

# Display installed packages
apt list --installed | \
	grep -E "apache2|mysql-server-$MYSQL_VERSION|php$PHP_VERSION" | \
	awk '{print $1, $2}'

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 MySQL Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
