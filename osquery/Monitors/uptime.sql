/*
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
# Name: Osquery Monitor - Uptime
# Description: Check for uptime of the device
# Language: Osquery
# Timeout: 100
# Version: 1.0
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Osquery Monitor - Uptime
# Script output: Greater than
# Output value: 30 (days)
# Run frequency: Hours
# Duration: 12
# -----------------------------------------------------------------------------
*/

SELECT days FROM uptime;