# common_functions.fish
# Last Updated: 2024-02-01


# Function to ensure logs folder exists with correct permissions and ownership
# Returns 0 on success, non-zero on failure
if test -d /var/www/provision/logs
	# Set permissions to allow the current user to write and others to read
	chmod -R 744 /var/www/provision/logs

	set -U LOGS_FOLDER_EXISTS 0  # Success
else
	# Create the folder
	mkdir -p $PROVISION_LOGS
	set -U LOGS_FOLDER_EXISTS $status
end

