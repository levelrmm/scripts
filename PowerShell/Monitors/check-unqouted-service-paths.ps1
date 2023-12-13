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
# Name: Windows Monitor - Check for Unqouted Service Paths
# Description: Search Windows Services and identify any services that contain 
# spaces in the path, but no double quotes. Unqouted Service paths create a 
# privilege escalation vulnerability in windows. See CVE-2023-32658.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Check for Unqouted Service Paths
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 24
# -----------------------------------------------------------------------------

# Get Services with a space in the file path, but no double quotes around it.
$services = Get-WmiObject -Class win32_service -Filter "StartMode='Auto' AND NOT PathName LIKE 'c:\\Windows\\%' AND PathName LIKE '% %' AND NOT PathName LIKE '%`"%'"

# Alert if services are found. 
if($services -ne $null){
  Write-Output "ALERT"
  Exit 1
}
