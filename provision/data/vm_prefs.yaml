#!/bin/zsh

# vm_data.sh
# `source ./relative/path/to/vm_data.sh`

# The variables below define your vagrant VM.
# Make any changes BEFORE creating your VM.
# Be very cautious about changing anything other than...
# --
# Strongly consider changing:
#   VM_TLDS
#   VM_HOSTNAME
#   VM_IP
#   TIMEZONE
# --
# Absolutely change:
#   ROOT_PASSWORD
#   DB_USERNAME
#   DB_PASSWORD
# --

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/          Vagrantfile Data           /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Machine Variables
VM_HOSTNAME="p2vagrant"
VM_IP="192.168.22.42"                   # 22 = titanium, 42 = Douglas Adams's number
TIMEZONE="Australia/Brisbane"           # "Europe/London"
MEMORY=4096
CPUS=1

# Synced Folders
HOST_FOLDER="."
VM_FOLDER="/var/www"

# Software Versions
PHP_VERSION="8.3"
MYSQL_VERSION="8.3"
SWIFT_VERSION="5.9.2"                   # For installing Swift (optional)

# Database Variables
ROOT_PASSWORD="RootPassw0rd"
DB_USERNAME="fredspotty"
DB_PASSWORD="Passw0rd"
DB_NAME="example_db"
DB_NAME_TEST="example_db_test"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/           p2vagrant Data            /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# One entry for every dev TLD to be used on your VM
# This can be added to later, but removing items once
# they have been used should be done with great care.
# Items must not conflict with TLDs used anywhere that
# is network accessible to the host.
VM_TLDS=(
	"test"
)
# Present a p2vagrant zenity options screen on VM startup.
# ### For future implementation ###
USE_OPTIONS=false
