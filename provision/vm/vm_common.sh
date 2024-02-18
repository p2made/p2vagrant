#!/bin/zsh

# provision/vm/vm_common.sh
# Usage...
# `source ./relative/path/to/vm_common.sh`

# Sparse array of Vagrantfiles, indexed by setup step...
VAGRANTFILES_INDEXES=(1 2 3 4 5 6 7 9)
VAGRANTFILES[1]="Create Bare VM"
VAGRANTFILES[2]="Upgrade VM"
VAGRANTFILES[3]="Install Utilities"
VAGRANTFILES[4]="Install Swift (optional)"
VAGRANTFILES[5]="Install Apache (with SSL & Markdown)"
VAGRANTFILES[6]="Install PHP (with Composer)"
VAGRANTFILES[7]="Install MySQL"
VAGRANTFILES[9]="Configure Sites"

# Sparse array of provisioning script calls, indexed by setup step...
PROVISIONING_INDEXES=(3 4 5 6 7 9)
PROVISIONING_ITEMS[3]='config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [VM_HOSTNAME, TIMEZONE]'
PROVISIONING_ITEMS[4]='config.vm.provision :shell, path: "provision/scripts/install_swift.sh", args: [SWIFT_VERSION]'
PROVISIONING_ITEMS[5]='config.vm.provision :shell, path: "provision/scripts/install_apache.sh"'
PROVISIONING_ITEMS[6]='config.vm.provision :shell, path: "provision/scripts/install_php.sh", args: [PHP_VERSION]'
PROVISIONING_ITEMS[7]='config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]'
PROVISIONING_ITEMS[9]='config.vm.provision :shell, path: "provision/scripts/configure_sites.sh"'

# Function for error handling
# Usage: handle_error "Error message"
function handle_error() {
	echo "⚠️   Error: $1 💥"
	echo "Run 'vagrant halt' then restore the last snapshot before trying again."
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success() {
	icon="✅"

	if [ -n "$2" ] && [ "$2" -eq 1 ]; then
		icon="👍"
	fi

	echo "$icon  $1"
}

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job() {
	echo "👍  $1"
}

# Function to give a debugging message
# Usage: debug_message "$FUNCNAME" "$LINENO" "Message."
function debug_message() {
	echo "‼️‼️  Debug in $1 at line $2: $3 🚨"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Banner constants
FLAGS=" 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"

# Function to write shalom peace salam banner
# Usage: peace_banner i - where i is 1 to 4
function peace_banner() {
    case $1 in
        1) # Binary
            cat <<EOF
🇺🇦           🕊️  01110011 01101000 01100001 01101100 01101111 01101101 🕊️
🇺🇦           🕊️  01110000 01100101 01100001 01100011 01100101          🕊️
🇺🇦           🕊️  01110011 01100001 01101100 01100001 01101101          🕊️
EOF
            ;;
        2) # Hexadecimal
            cat <<EOF
🇺🇦           🕊️  73 68 61 6C 6F 6D 🕊️
🇺🇦           🕊️  70 65 61 63 65    🕊️
🇺🇦           🕊️  73 61 6C 61 6D    🕊️
EOF
            ;;
        3) # Octal
            cat <<EOF
🇺🇦           🕊️  163 150 141 154 157 155 🕊️
🇺🇦           🕊️  160 145 141 143 145     🕊️
🇺🇦           🕊️  163 141 154 141 155     🕊️
EOF
            ;;
        4) # Morse Code
            cat <<EOF
🇺🇦           🕊️  ... .... .- .-.. --- -- 🕊️
🇺🇦           🕊️     .--. . .- -.-. .     🕊️
🇺🇦           🕊️     ... .- .-.. .- --    🕊️
EOF
            ;;
    esac
}

# Function to write update banner
# Usage: upgrade_banner $active_title $script_name $updated_date
function manager_banner() {
    cat <<EOF
🇦🇺$FLAGS$FLAGS$FLAGS$FLAGS$FLAGS
🇺🇦
🇺🇦                     ___                                     __
🇺🇦               ____ |__ \_   ______ _____ __________ _____  / /_
🇺🇦              / __ \__/ / | / / __ `/ __ `/ ___/ __ `/ __ \/ __/
🇺🇦             / /_/ / __/| |/ / /_/ / /_/ / /  / /_/ / / / / /_
🇺🇦            / .___/____/|___/\__,_/\__, /_/   \__,_/_/ /_/\__/
🇺🇦           /_/                    /____/
🇺🇦
🇺🇦               ____ ___  ____ _____  ____ _____ ____  _____
🇺🇦              / __ `__ \/ __ `/ __ \/ __ `/ __ `/ _ \/ ___/
🇺🇦             / / / / / / /_/ / / / / /_/ / /_/ /  __/ /
🇺🇦            /_/ /_/ /_/\__,_/_/ /_/\__,_/\__, /\___/_/
🇺🇦                                        /____/
🇺🇦
EOF
    peace_banner $(( (RANDOM % 4) + 1 ))
    cat <<EOF
🇺🇦
🇦🇺$FLAGS$FLAGS$FLAGS$FLAGS$FLAGS

EOF
}
