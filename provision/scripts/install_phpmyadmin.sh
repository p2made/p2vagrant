#!/bin/sh

# 09 Install phpMyAdmin

# Variables...
# 1 - PMA_USERNAME      = ⚠️ See Vagrantfile
# 2 - PMA_PASSWORD      = ⚠️ See Vagrantfile
# 3 - REMOTE_FOLDER     = "/var/www"

# Validate arguments
if [ -z "$2" ]; then
    echo "⚠️ Error: Missing phpMyAdmin database password 💥"
    exit 1
fi

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🚀 Installing phpMyAdmin 🚀"
echo "Script Name:  install_phpmyadmin.sh"
echo "Last Updated: 2024-01-20"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Add repository for phpMyAdmin
LC_ALL=C.UTF-8 sudo apt-add-repository -yu ppa:phpmyadmin/ppa

# Call the vm_upgrade.sh script
/var/www/provision/scripts/vm_upgrade.sh

# Install phpMyAdmin
sudo apt -qy install phpmyadmin

# Remove the default phpMyAdmin directory
sudo rm -rf /usr/share/phpmyadmin

# Copy phpMyAdmin to the specified folder
sudo cp -R $3/provision/html/phpmyadmin $3/html/phpmyadmin

# Set permissions
sudo chmod -R 755 $3/html/phpmyadmin

echo ""
echo "✅ phpMyAdmin installation completed successfully!"
echo ""

# Enable mbstring
sudo phpenmod mbstring

# Restart Apache to apply changes
sudo systemctl restart apache2

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 phpMyAdmin Installed ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
