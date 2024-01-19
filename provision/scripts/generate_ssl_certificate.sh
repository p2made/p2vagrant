#!/bin/bash

# 03 Generate Self-Signed SSL Certificate

# Variables...
SSL_DIR="/var/www/provision/ssl"
CERT_NAME="selfsigned"

echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🚀 Generating Self-Signed SSL Certificate 🚀"
echo "Script Name: 03_generate_ssl.sh"
echo "Last Updated: 2023-01-19"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Create SSL directory
mkdir -p $SSL_DIR

# Generate private key and certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout $SSL_DIR/$CERT_NAME.key -out $SSL_DIR/$CERT_NAME.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Display information about the generated certificate
openssl x509 -noout -text -in $SSL_DIR/$CERT_NAME.crt

echo ""
echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🏆 Self-Signed SSL Certificate Generated ‼️"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"

