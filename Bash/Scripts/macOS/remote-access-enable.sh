#!/bin/sh
# Operating System: macOS
# Enable Remote Access (SSH) for a macOS device.

# Ensure the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Try running with 'sudo'."
    exit 1
fi

# Inform the user
echo "Enabling SSH remote access..."

# Execute the command to enable remote login
systemsetup -f -setremotelogin on

# Provide feedback on the result
if [ $? -eq 0 ]; then
    echo "SSH remote access has been successfully enabled."
else
    echo "Failed to enable SSH remote access. Please check for errors."
    exit 1
fi

