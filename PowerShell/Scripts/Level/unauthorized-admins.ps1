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
# Name: Windows - Unauthorized Admins
# Description: This script compares the detected admins to the authorized admins list.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# CONFIGURE
# - AuthorizedAdmins
# - DetectedAdmins

# Custom Field: Authorized Admins
$AuthorizedAdmins = "{{cf_authorized_admins}}"

# Script Variable: detectedAdmins
$detectedAdmins = "{{detectedAdmins}}"

# Convert both lists to arrays and trim spaces
$detectedArray = $detectedAdmins -split ',' | ForEach-Object { $_.Trim().ToLower() }
$authorizedArray = $AuthorizedAdmins -split ',' | ForEach-Object { $_.Trim().ToLower() }

# Find admins in detected list but not in authorized list
# Convert both to lowercase for case-insensitive comparison
$unauthorizedAdmins = $detectedArray | Where-Object { $authorizedArray -notcontains $_ }

# Output unauthorized admins separated by commas
$unauthorizedString = $unauthorizedAdmins -join ','

if ($unauthorizedAdmins.Count -gt 0) {
    Write-Output "$unauthorizedString"
    exit 1
} else {
    Write-Output "No unauthorized admins detected."
    exit 0
}
