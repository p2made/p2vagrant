#!/bin/fish

# 06 Install phpMyAdmin

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing phpMyAdmin 🚀"
echo "🇺🇿    📜 Script Name:  06_install_phpmyadmin.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-28"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Variables...
# 1 - PMA_USERNAME      = ⚠️ See Vagrantfile
# 2 - PMA_PASSWORD      = ⚠️ See Vagrantfile
# 3 - REMOTE_FOLDER     = "/var/www"

# Shove data in here

# Source common functions
source /var/www/provision/scripts/common_functions.fish

#!/bin/sh

set -x DEBIAN_FRONTEND noninteractive

# Start _script_title_ logic...

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
# Functions

# Function form
#function function_name
#    ... Function body ...
#    if not [SOME_CHECK]
#        handle_error "Failed to perform some action."
#    end
#    announce_success "Successfully completed some action." # optional
#end

# Example usage:
#function_name
#function_name argument
#function_name argument1 argument2

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
# Execution

# single line statements
# including calls to functions

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 phpMyAdmin Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"

# -- -- // -- -- // -- -- // -- -- // -- -- // -- --

# Add repository for phpMyAdmin
LC_ALL=C.UTF-8 sudo apt-add-repository -yu ppa:phpmyadmin/ppa

# Set phpMyAdmin database user and password for debconf selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true"             | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/db/app-user string $1"                     | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $2"                | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $2"          | sudo debconf-set-selections

# Install phpMyAdmin
sudo apt -qy install phpmyadmin

# Remove the default phpMyAdmin directory
sudo rm -rf /usr/share/phpmyadmin

# Copy phpMyAdmin to the specified folder
sudo cp -R $3/provision/html/phpmyadmin $3/html/phpmyadmin

# Set permissions
sudo chmod -R 755 $3/html/phpmyadmin

# Enable mbstring
sudo phpenmod mbstring

# Restart Apache to apply changes
sudo systemctl restart apache2

