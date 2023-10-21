#!/bin/bash
# Operating System: macOS

# Ensure the script is running with root permissions
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if the socketfilterfw tool is available
if ! command -v /usr/libexec/ApplicationFirewall/socketfilterfw &> /dev/null; then
    echo "Error: socketfilterfw is not available on this system."
    exit 1
fi

# Enable the Application Level Firewall (ALF)
if /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on; then
    echo "Application Level Firewall (ALF) is now enabled."
else
    echo "Failed to enable Application Level Firewall (ALF)."
    exit 1
fi

