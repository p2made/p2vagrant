#!/bin/sh

# 02 Upgrade VM

echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🚀 Upgrading VM 🚀"
echo "Script Name: $0"
echo "Last Updated: 2023-01-19"
echo "Should always run first "
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

apt-get -q update
apt-get -qy upgrade
apt-get autoremove
cat /etc/os-release

echo ""
echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🏆 Upgrade compleded successfully ‼️"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
