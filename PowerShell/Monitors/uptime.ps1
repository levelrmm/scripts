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
# Name: Windows Monitor - System Uptime
# Description: Check for uptime of the computer
# Language: PowerShell
# Timeout: 100
# Version: 1.0
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - System Uptime
# Script output: Greater than
# Output value: 30 (days)
# Run frequency: Hours
# Duration: 12
# -----------------------------------------------------------------------------

# Get uptime of device
$uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime | Select-Object -ExpandProperty TotalDays

# Round it to a whole number
$uptime = [math]::Round($uptime)

# Return uptime
Write-Host $uptime