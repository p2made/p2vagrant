#!/bin/sh

# 07 Install MySQL

# Variables...
# 1 - MYSQL_VERSION   = "8.1"
# 2 - DB_USERNAME     = "fredspotty"
# 3 - DB_PASSWORD     = "Passw0rd"
# 4 - DB_NAME         = "example_db"
# 5 - DB_NAME_TEST    = "example_db_test"

echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🚀 Installing MySQL 🚀"
echo "Script Name:  install_mysql.sh"
echo "Last Updated: 2024-01-20"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Function to update package lists
echo "🔄 Updating package lists 🔄"
if ! apt-get -q update; then
	handle_error "⚠️ Failed to update package lists"
fi

apt-get -qy install mysql-server

# Create the database and grant privileges
echo "CREATE USER '$2'@'%' IDENTIFIED BY '$3'"      | mysql
echo "CREATE DATABASE IF NOT EXISTS $4"             | mysql
echo "CREATE DATABASE IF NOT EXISTS $5"             | mysql
echo "GRANT ALL PRIVILEGES ON $4.* TO '$2'@'%';"    | mysql
echo "GRANT ALL PRIVILEGES ON $5.* TO '$2'@'%';"    | mysql
echo "flush privileges"                             | mysql

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

cp /var/www/provision/html/db.php /var/www/html/

sudo chmod -R 755 /var/www/html/*

dpkg -l | grep "apache2\|mysql-server-8.1\|php8.2"

echo ""
echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🏆 MySQL Installed ‼️"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
