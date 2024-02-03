#!/bin/fish

# 06 Install MySQL

set script_name     "install_mysql.fish"
set updated_date    "2024-02-02"

set active_title    "Installing MySQL"
set job_complete    "MySQL Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - MYSQL_VERSION   = "8.1"
# 2 - PHP_VERSION     = "8.3"
# 3 - ROOT_PASSWORD   = ⚠️ See Vagrantfile
# 4 - DB_USERNAME     = ⚠️ See Vagrantfile
# 5 - DB_PASSWORD     = ⚠️ See Vagrantfile
# 6 - DB_NAME         = "example_db"
# 7 - DB_NAME_TEST    = "example_db_test"

# Script variables...

set MYSQL_VERSION  $argv[1]
set PHP_VERSION    $argv[2]
set ROOT_PASSWORD  $argv[3]
set DB_USERNAME    $argv[4]
set DB_PASSWORD    $argv[5]
set DB_NAME        $argv[6]
set DB_NAME_TEST   $argv[7]

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	mysql-server

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

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
cp $PROVISION_HTML/db.php $SHARED_HTML/ || \
	handle_error "Failed to copy db.php file"

# Set permissions
sudo chmod -R 755 $SHARED_HTML/ || \
	handle_error "Failed to set permissions on $SHARED_HTML/"

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
