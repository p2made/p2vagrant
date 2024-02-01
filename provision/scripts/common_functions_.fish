#!/bin/fish

# common_functions.fish
# Last Updated: 2024-02-01

# Script constants...

# TODAYS_DATE         $(date "+%Y-%m-%d")
# VM_FOLDER           /var/www
# SHARED_HTML          $VM_FOLDER/html
# PROVISION_FOLDER    $VM_FOLDER/provision
# PROVISION_DATA      $VM_FOLDER/provision/data
# PROVISION_HTML      $VM_FOLDER/provision/html
# PROVISION_LOGS      $VM_FOLDER/provision/logs
# PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
# PROVISION_SSL       $VM_FOLDER/provision/ssl
# PROVISION_TEMPLATES $VM_FOLDER/provision/templates
# PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

set -U TODAYS_DATE         (date "+%Y-%m-%d")
#set -U TODAYS_DATE         $(date "+%Y-%m-%d")
set -U VM_FOLDER           /var/www
set -U SHARED_HTML         $VM_FOLDER/html
set -U PROVISION_FOLDER    $VM_FOLDER/provision
set -U PROVISION_DATA      $VM_FOLDER/provision/data
set -U PROVISION_HTML      $VM_FOLDER/provision/html
set -U PROVISION_LOGS      $VM_FOLDER/provision/logs
set -U PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
set -U PROVISION_SSL       $VM_FOLDER/provision/ssl
set -U PROVISION_TEMPLATES $VM_FOLDER/provision/templates
set -U PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

set -U LOGS_FOLDER_EXISTS  ensure_logs_folder
set -U LOG_FILE_TAIL       "_log.txt"

# Function for error handling
# Usage: handle_error "Error message" "Error details"
function handle_error
	set log_file_name (set_log_file_name "errors")
	set log_file (provide_log_file $log_file_name)
	set custom_error_message (echo "⚠️ Error: $argv[1] 💥")

	# Write the common log lines
	write_log_banner $log_file 1

	# Output the error message and details to the log
	echo $custom_error_message >> $log_file
	echo "Error details: $argv[2]" >> $log_file

	echo $custom_error_message
	exit 1
end

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success
	set icon "✅"

	if test -n "$argv[2]"
		if test "$argv[2]" -eq 1
			set icon "👍"
		end
	end

	echo "$icon $argv[1]"
end

# Function to update package with error handling
# Usage: update_package_lists
function update_package_lists
	echo "🔄 Updating package lists 🔄"

	set log_file_name (set_log_file_name "updates")
	set log_file (provide_log_file $log_file_name)

	# Write the common log lines
	write_log_banner $log_file 0

	# Capture the output and error message
	set update_result (command apt-get update ^&1 | tr -d '\n')

	# Write the common log lines
	write_log_banner $log_file 0

	# Check the exit status
	if test $status -ne 0
		# Extract the error message
		set error_message (echo $update_result | tr -d '\n')
		handle_error "Failed to update package lists" $error_message
	end

	announce_success "Package lists updated successfully."
end

# Function to install packages with error handling
# Usage: install_packages $name $package_list
function install_packages
	echo "🔄 Installing Packages 🔄"

	set name $argv[1]
	set package_list $argv[2..-1]  # Exclude the first argument (name)

	set log_file_name (set_log_file_name $name)
	set log_file (provide_log_file $log_file_name)

	# Write the common log lines
	write_log_banner $log_file $name

	for package in $package_list
		set cleaned (echo $package)
		echo "🔄 Installing: $cleaned" >> $log_file

		# Capture the output and error message
		set install_result (command apt-get -y install $cleaned ^&1 | tr -d '\n')

		# Append the output to the log file
		echo $install_result >> $log_file

		# Check the exit status
		if test $status -ne 0
			# Extract the error message
			set error_message (echo $install_result | tr -d '\n')
			handle_error "Failed to install package: $cleaned" $error_message
		end
	end

	announce_success "Packages installed successfully!"
end

# Function to update package lists the install packages with error handling
# invokes update_package_lists & install_packages in a single call
# Usage: update_and_install_packages $package_list
function update_and_install_packages
	update_package_lists
	install_packages $argv
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to write common log lines
# Usage: write_log_banner $log_file 0/1/string
function write_log_banner
	switch $argv[2]
		case 0
			set banner_art "🔄 /%/ p2m /%/ -- 🔄 UPDATING 🔄 UPDATING 🔄 -- /%/ p2m /%/ 🔄"
		case 1
			set banner_art "🚨 /%/ p2m /%/ -- 🚨 ERROR 🚨 ERROR 🚨 ERROR 🚨 -- /%/ p2m /%/ 🚨"
		case '*'
			set banner_art "🔄 /%/ p2m /%/ -- 🔄 $argv[2] 🔄 -- /%/ p2m /%/ 🔄"
	end

	echo $banner_art >> $argv[1]
	echo "$TODAYS_DATE (date '+%T')" >> $argv[1]
end

# Function to ensure logs folder exists with correct permissions and ownership
# Returns 0 on success, non-zero on failure
function ensure_logs_folder
	# Check if the folder exists
	if test -d $PROVISION_LOGS
		# Set permissions to allow the current user to write and others to read
		chmod -R 744 $PROVISION_LOGS

		return 0  # Success
	else
		# Create the folder
		mkdir -p $PROVISION_LOGS
		return $status
	end
end

# Function to return the log file name
# Usage: set_log_file_name "<name>"
function set_log_file_name
	return "$argv[1]_log.txt"
end

# Function to provide a log file
# Returns path to the log file if the log file already exists or is created successfully.
# Exits via handle_error on failure.
# Usage: provide_log_file "full_log_file_name"
function provide_log_file
	if test $LOGS_FOLDER_EXISTS -ne 0
		handle_error "No logs folder"
	end

	set log_file (echo $PROVISION_LOGS/$argv[1])

	if test -e $log_file
		# Log file already exists, return success
		return $log_file
	end

	touch $log_file

	if test $status -ne 0
		handle_error "Unable to create log file: $argv[1]"
	end

	return $log_file
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function header_banner
	echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
	echo "🇺🇦"
	echo "🇺🇦    🚀 $argv[1] 🚀"
	echo "🇺🇦        on 📅 $TODAYS_DATE 📅"
	echo "🇺🇦"
	echo "🇺🇦    📜 Script Name:  $argv[2]"
	echo "🇺🇦    📅 Last Updated: $argv[3]"
	echo "🇺🇦"
	echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳"
	echo ""
end

function footer_banner
	echo ""
	echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
	echo "🇺🇦"
	echo "🇺🇦    🏆 $argv[1] ‼️"
	echo "🇺🇦"
	echo "🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳"
end
