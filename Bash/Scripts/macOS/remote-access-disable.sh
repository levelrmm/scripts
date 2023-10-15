#!/bin/bash
# Operating System: macOS
# Disable Remote Access (SSH) for a macOS device.

# Ensure the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Try running with 'sudo'."
    exit 1
fi

# Inform the user
echo "Disabling SSH remote access..."

# Execute the command to disable remote login
systemsetup -setremotelogin off

# Provide feedback on the result
if [ $? -eq 0 ]; then
    echo "SSH remote access has been successfully disabled."
else
    echo "Failed to disable SSH remote access. Please check for errors."
    exit 1
fi

