#!/bin/sh

# 07 Install MySQL

# Variables...
# 1 - MYSQL_VERSION   = "8.1"
# 2 - DB_USERNAME     = ⚠️ See Vagrantfile
# 3 - DB_PASSWORD     = ⚠️ See Vagrantfile
# 4 - DB_NAME         = "example_db"
# 5 - DB_NAME_TEST    = "example_db_test"

# Function for error handling
handle_error() {
	echo "⚠️ Error: $1 💥"
	exit 1
}

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🚀 Installing MySQL 🚀"
echo "📜 Script Name:  install_mysql.sh"
echo "📅 Last Updated: 2024-01-20"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Call the vm_upgrade.sh script
/var/www/provision/scripts/vm_upgrade.sh || handle_error "Failed to upgrade VM"

# Install MySQL
if ! apt-get -qy install mysql-server; then
	handle_error "Failed to install MySQL"
fi

# Create the database and grant privileges
echo "CREATE USER '$2'@'%' IDENTIFIED BY '$3'"      | mysql || handle_error "Failed to create MySQL user"
echo "CREATE DATABASE IF NOT EXISTS $4"             | mysql || handle_error "Failed to create MySQL database $4"
echo "CREATE DATABASE IF NOT EXISTS $5"             | mysql || handle_error "Failed to create MySQL database $5"
echo "GRANT ALL PRIVILEGES ON $4.* TO '$2'@'%';"    | mysql || handle_error "Failed to grant privileges on $4"
echo "GRANT ALL PRIVILEGES ON $5.* TO '$2'@'%';"    | mysql || handle_error "Failed to grant privileges on $5"
echo "flush privileges"                             | mysql || handle_error "Failed to flush privileges"

# Update MySQL configuration
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Copy database file
cp /var/www/provision/html/db.php /var/www/html/ || handle_error "Failed to copy db.php file"

# Set permissions
sudo chmod -R 755 /var/www/html/ || handle_error "Failed to set permissions on /var/www/html/"

# Display installed packages
dpkg -l | grep "apache2\|mysql-server-$1\|php8.2"

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 MySQL Installed ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
