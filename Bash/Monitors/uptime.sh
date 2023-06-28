#!/bin/bash
# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment.  We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Linux Monitor - System Uptime
# Description: Check for uptime of the device
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - System Uptime
# Script output: Greater than
# Output value: 30 (days)
# Run frequency: Hours
# Duration: 12
# -----------------------------------------------------------------------------

# Get uptime of the system in seconds
uptime_seconds=$(awk '{print $1}' /proc/uptime)

# Calculate uptime in days
uptime_days=$(bc <<< "scale=2; $uptime_seconds / (60 * 60 * 24)")

# Round uptime to a whole number
uptime=$(printf "%.0f" "$uptime_days")

# Return uptime
echo $uptime
