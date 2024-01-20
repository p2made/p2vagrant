#!/bin/bash

# 03 Generate Self-Signed SSL Certificate

# Variables...
# 1 - SSL_DIR         = "/var/www/provision/ssl"
# 2 - CERT_NAME       = "p2_selfsigned"

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🚀 Generating Self-Signed SSL Certificate 🚀"
echo "📜 Script Name:  generate_ssl.sh"
echo "📅 Last Updated: 2024-01-20"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Create SSL directory
mkdir -p $1

# Generate private key and certificate
openssl req -x509 -nodes -days 999 -newkey rsa:2048 \
  -keyout $1/$2.key -out $1/$2.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Display information about the generated certificate
openssl x509 -noout -text -in $1/$2.crt

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 Self-Signed SSL Certificate Generated ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
