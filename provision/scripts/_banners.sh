#!/bin/bash

# _banners.sh
# Updated: 2024-02-14

# Script constants...
au="🇦🇺"
ua="🇺🇦"
btbu=" 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
btb="$au$btbu$btbu$btbu$btbu$btbu"





# Function to write banner opening
# Usage: banner_open
function banner_open() {
	echo "$btb"
	echo "$ua"
}

# Function to write banner closing
# Usage: banner_close
function banner_close() {
	echo "$ua"
	echo "$btb"
}

# Usage: banner_p2vagrant
function banner_p2vagrant() {
	echo "$ua                     ___                                     __"
	echo "$ua               ____ |__ \_   ______ _____ __________ _____  / /_"
	echo "$ua              / __ \__/ / | / / __ \`/ __ \`/ ___/ __ \`/ __ \/ __/"
	echo "$ua             / /_/ / __/| |/ / /_/ / /_/ / /  / /_/ / / / / /_"
	echo "$ua            / .___/____/|___/\__,_/\__, /_/   \__,_/_/ /_/\__/"
	echo "$ua           /_/                    /____/"
}

# Usage: banner_p2project
function banner_p2project() {
	echo "$ua                             _"
	echo "$ua                            (_)____   ____ _"
	echo "$ua                           / / ___/  / __ \`/"
	echo "$ua                          / (__  )  / /_/ /   _ _ _"
	echo "$ua                         /_/____/   \__,_/   (_|_|_)"
	echo "$ua"
	echo "$ua                             ___"
	echo "$ua                       _____|_  )                   _           _"
	echo "$ua              /\      |  __ \/ /                   (_)         | |"
	echo "$ua             /  \     | |__)/___|   _ __  _ __ ___  _  ___  ___| |_"
	echo "$ua            / /\ \    |  ___/      | '_ \| '__/ _ \| |/ _ \/ __| __|"
	echo "$ua           / ____ \   | |          | |_) | | | (_) | |  __/ (__| |_"
	echo "$ua          /_/    \_\  |_|          | .__/|_|  \___/| |\___|\___|\__|"
	echo "$ua                                   | |            _/ |"
	echo "$ua                                   |_|           |__/"
}

# Usage: banner_details $active_title $script_name $updated_date
function banner_details() {
	echo "$ua           🚀 $1 🚀"
	echo "$ua           📅     on $TODAYS_DATE"
	echo "$ua"
	echo "$ua           📜 Script Name:  $2"
	echo "$ua           📅 Last Updated: $3"
}

# Function to write shalom peace salam banner
# Usage: peace_banner i - where i is 1 to 4
function peace_banner() {
	case $1 in
		1) # Binary
			echo "$ua           🕊️  01110011 01101000 01100001 01101100 01101111 01101101 🕊️"
			echo "$ua           🕊️  01110000 01100101 01100001 01100011 01100101          🕊️"
			echo "$ua           🕊️  01110011 01100001 01101100 01100001 01101101          🕊️"
			;;
		2) # Hexadecimal
			echo "$ua           🕊️  73 68 61 6C 6F 6D 🕊️"
			echo "$ua           🕊️  70 65 61 63 65    🕊️"
			echo "$ua           🕊️  73 61 6C 61 6D    🕊️"
			;;
		3) # Octal
			echo "$ua           🕊️  163 150 141 154 157 155 🕊️"
			echo "$ua           🕊️  160 145 141 143 145     🕊️"
			echo "$ua           🕊️  163 141 154 141 155     🕊️"
			;;
		4) # Morse Code
			echo "$ua           🕊️  ... .... .- .-.. --- -- 🕊️"
			echo "$ua           🕊️     .--. . .- -.-. .     🕊️"
			echo "$ua           🕊️     ... .- .-.. .- --    🕊️"
			;;
	esac
}

# Function to write update banner
# Usage: upgrade_banner $active_title $script_name $updated_date
function upgrade_banner() {
	banner_open
	banner_p2vagrant
	echo "$ua"
	banner_p2project
	echo "$ua"
	banner_details "$1" "$2" "$3"
	banner_close
	echo ""
}

# Function to write header banner
# Usage: header_banner $active_title $script_name $updated_date
function header_banner() {
	banner_open
	banner_p2vagrant
	echo "$ua"
	banner_details "$1" "$2" "$3"
	banner_close
	echo ""
}

# Function to write footer banner
# Usage: footer_banner $job_complete
function footer_banner() {
	echo ""
	banner_open
	echo "$ua           🏆 $1 ‼️"
	echo "$ua"
	peace_banner $(( (RANDOM % 4) + 1 ))
	echo "$ua"
	echo "$ua p2vagrant - (c) Pedro Plowman, Australia 🇦🇺 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳"
	banner_close
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

