#!/bin/bash
# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Linux Monitor - Check USB Drive Presence
# Description: Check if USB Drive is present
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - Check USB Drive Presence
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# Look for USB Drives
USBDrivePresent=$(lsblk -o NAME,TRAN | grep "usb" | awk '{print $1}')

if [ -n "$USBDrivePresent" ]; then
    # If USB drive is present, send console message for Level to alert on
    echo "ALERT"
fi
