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
# Name: Windows Monitor - Registry Setting
# Description: This script monitors the existence of a registry setting and 
# alerts if it is not found.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Registry Setting
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - registry_key

# Registry key to monitor
$registryKey = "HKLM:\Software\Example"

# -----------------------------------------------------------------------------

# Check if the registry key exists
if (!(Test-Path -Path $registryKey)) {
  Write-Host "ALERT: Registry setting not found: $registryKey"
  exit 1
}

Write-Host "SUCCESS"
