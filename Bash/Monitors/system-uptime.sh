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
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 12
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - uptime_policy

# Number of days before an alert
uptime_policy=45
# -----------------------------------------------------------------------------

# Get uptime of the system in seconds
uptime_seconds=$(awk '{print $1}' /proc/uptime)

# Calculate uptime in days
uptime_days=$(bc <<< "scale=2; $uptime_seconds / (60 * 60 * 24)")

# Round uptime to a whole number
uptime=$(printf "%.0f" "$uptime_days")

# If threshold breached, generate an alert
if (( uptime > uptime_policy )); then
  echo -e "ALERT: device uptime expected to be less than $uptime_policy. Uptime was $uptime days.\n"
else
  echo "SUCCESS"
fi
