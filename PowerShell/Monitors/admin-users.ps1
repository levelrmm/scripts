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
# Name: Windows Monitor - Admin Users
# Description: This script identifies unexpected users with administrative 
# privileges, excluding those in the excluded list. It alerts for any unexpected
# users found and displays an error message with the list of unexpected users 
# if any are detected.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Admin Users
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - excluded_admin_users

# Array of known admin users to exclude from output
$excluded_admin_users = @("Administrator", "Level")
# -----------------------------------------------------------------------------

# Get a list of all users with administrative privileges
$admin_users = (Get-WmiObject -Class Win32_UserAccount | Where-Object { $_.LocalAccount -eq $true -and $_.Disabled -eq $false -and $_.PasswordRequired -eq $true -and $_.SID -notlike "*-500" }).Name

# Variables to track the number of unexpected admin users found
$unexpected_count = 0
$unexpected_users = ""

# Alert on unexpected admin users
foreach ($user in $admin_users) {
  if ($excluded_admin_users -notcontains $user) {
    Write-Host "ALERT: Unexpected admin user found: $user"
    $unexpected_count++
    $unexpected_users += " $user"
  }
}

# Check if any unexpected users were found
if ($unexpected_count -gt 0) {
  Write-Host "ALERT: $unexpected_count unexpected admin users found"
  Write-Host "Unexpected admin users found: $unexpected_users"
}
else {
  Write-Host "SUCCESS"
}
