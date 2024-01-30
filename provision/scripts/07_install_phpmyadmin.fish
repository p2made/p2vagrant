#!/bin/fish

# 06 Install phpMyAdmin

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing phpMyAdmin 🚀"
echo "🇺🇿    📜 Script Name:  07_install_phpmyadmin.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-28"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Arguments...
# 1 - REMOTE_FOLDER     = "/var/www"

set REMOTE_FOLDER $argv[1]

set PACKAGE_LIST \
	phpmyadmin

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Add repository for phpMyAdmin
LC_ALL=C.UTF-8 sudo apt-add-repository -yu ppa:phpmyadmin/ppa

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

# Remove the default phpMyAdmin directory
rm -rf /usr/share/phpmyadmin

# Copy phpMyAdmin to the specified folder
cp -R $REMOTE_FOLDER/provision/html/phpmyadmin $REMOTE_FOLDER/html/phpmyadmin

# Set permissions
chmod -R 755 $REMOTE_FOLDER/html/phpmyadmin

# Enable mbstring
phpenmod mbstring

# Restart Apache to apply changes
systemctl restart apache2

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 phpMyAdmin Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
