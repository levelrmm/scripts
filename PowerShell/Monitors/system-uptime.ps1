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
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 12
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - uptime_policy

# Number of days before an alert
$uptime_policy = 45
# -----------------------------------------------------------------------------

# Get uptime of device
$uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime | Select-Object -ExpandProperty TotalDays

# Round it to a whole number
$uptime = [math]::Round($uptime)

if ($uptime -gt $uptime_policy) {
    # If threshold breached, generate an alert
    Write-Host "ALERT"
}
else {
    # Uptime within acceptable range, output success message
    Write-Host "SUCCESS"
}