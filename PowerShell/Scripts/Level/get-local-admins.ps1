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
# Name: Windows - Get Local Admins
# Description: Get local administrators as a comma seperated list
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------

# Get all local admins that are enabled
$admins = Get-LocalGroupMember -Group "Administrators" | 
          Where-Object { $_.ObjectClass -eq 'User' -and (Get-LocalUser $_.SID).Enabled -eq $true } | 
          Select-Object -ExpandProperty Name

# Extract just the username by splitting on '\' and taking the last part
$admins = $admins | ForEach-Object { ($_ -split '\\')[-1] }

# Join the usernames into a single string separated by commas
$detectedAdmins = $admins -join ","

# Output for verification
Write-Output $detectedAdmins
