#!/bin/fish

# common_functions.fish
# Last Updated: 2024-01-29

# Function for error handling
# Usage: handle_error "Error message"
function handle_error
	echo "⚠️ Error: $argv 💥"
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

# Function to update package lists the install packages with error handling
# Usage: install_packages $package_list
function update_and_install_packages
	echo "🔄 Updating package lists 🔄"

	if not apt-get -q update > /dev/null 2>&1
		handle_error "Failed to update package lists"
	end

	announce_success "Package lists updated successfully."

	echo "🔄 Installing Packages 🔄"

	for package in $argv
		set cleaned (eval echo $package)
		if not apt-get -qy install $cleaned
			handle_error "Failed to install packages"
		end
	end

	announce_success "Packages installed successfully!"
end
