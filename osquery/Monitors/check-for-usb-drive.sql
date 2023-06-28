/*
# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Osquery Monitor - Check USB Drive Presence
# Description: Check if USB Drive is present
# Language: Osquery
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Osquery Monitor - Check USB Drive Presence
# Script output: Equals
# Output value: true
# Run frequency: Minutes
# Duration: 1
# -----------------------------------------------------------------------------
*/

SELECT CASE WHEN COUNT(*) > 0 THEN 'true' ELSE 'false' END AS usb_drive_present
FROM disk_info
WHERE type LIKE '%USB%' OR description LIKE '%USB%';
