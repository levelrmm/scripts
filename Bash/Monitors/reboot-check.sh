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
# Name: Linux Monitor - Reboot Check
# Description: This script checks to see if reboot is required.
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - Reboot Check
# Script output: Contains
# Output value: ALERT
# Run frequency: Hour
# Duration: 1
# -----------------------------------------------------------------------------

if [ -f /var/run/reboot-required ]; then
  echo 'ALERT: Reboot Required'
else
  echo "No reboot is required."
fi
