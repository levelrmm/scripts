# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Monitor - Unauthorized Admins
# Description: Check for Unauthorized Admins using Custom Field.
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Check Bitlocker Status
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 1
# -----------------------------------------------------------------------------

# Custom Field: Authorized Admins (must update to match your custom field name)
$AuthorizedAdmins = "{{cf_authorized_admins}}"

# Get all local admins that are enabled
$admins = Get-LocalGroupMember -Group "Administrators" | 
          Where-Object { $_.ObjectClass -eq 'User' -and (Get-LocalUser $_.SID).Enabled -eq $true } | 
          Select-Object -ExpandProperty Name

# Extract just the username by splitting on '\' and taking the last part
$admins = $admins | ForEach-Object { ($_ -split '\\')[-1] }

# Join the usernames into a single string separated by commas
$adminString = $admins -join ","

# Store in a custom field (assuming you mean a variable for this context)
$detectedAdmins = $adminString

# Convert both lists to arrays and trim spaces
$detectedArray = $detectedAdmins -split ',' | ForEach-Object { $_.Trim().ToLower() }
$authorizedArray = $AuthorizedAdmins -split ',' | ForEach-Object { $_.Trim().ToLower() }

# Find admins in detected list but not in authorized list
# Convert both to lowercase for case-insensitive comparison
$unauthorizedAdmins = $detectedArray | Where-Object { $authorizedArray -notcontains $_ }

# Output unauthorized admins separated by commas
$unauthorizedString = $unauthorizedAdmins -join ','

if ($unauthorizedAdmins.Count -gt 0) {
    Write-Output "ALERT: Unauthorized Admins Detected -- $unauthorizedString"
    exit 1
} else {
    Write-Output "No unauthorized admins detected."
    exit 0
}
