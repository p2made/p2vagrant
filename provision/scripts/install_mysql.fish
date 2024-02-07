#!/bin/fish

# 06 Install MySQL
# Updated: 2024-02-07

set script_name     "install_mysql.fish"
set updated_date    "2024-02-04"

set active_title    "Installing MySQL"
set job_complete    "MySQL Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
set MYSQL_VERSION  $argv[1] # "8.0"
set PHP_VERSION    $argv[2] # "8.3"
set ROOT_PASSWORD  $argv[3] # ⚠️ See Vagrantfile
set DB_USERNAME    $argv[4] # ⚠️ See Vagrantfile
set DB_PASSWORD    $argv[5] # ⚠️ See Vagrantfile
set DB_NAME        $argv[6] # "example_db"
set DB_NAME_TEST   $argv[7] # "example_db_test"

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	mysql-server

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

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
if not test -f /etc/mysql/mysql.conf.d/mysqld.cnf
	handle_error "mysqld.cnf file not found."
end

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Copy database file
cp $PROVISION_HTML/db.php $SHARED_HTML/ || \
	handle_error "Failed to copy db.php file"

# Set permissions
sudo chmod -R 755 $SHARED_HTML/ || \
	handle_error "Failed to set permissions on $SHARED_HTML/"

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
