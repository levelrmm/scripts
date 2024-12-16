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
# Name: Windows Monitor - Unauthorized Application
# Description: This script identifies applications that aren't authorized.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Unauthorized Application
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 30
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE: Level Custom Field
# - cf_authorized_applications
# -----------------------------------------------------------------------------

# Convert the custom field to an array, handling null or empty cases
$AuthorizedApps = if ("{{cf_authorized_applications}}" -ne "") {
    "{{cf_authorized_applications}}" -split ","
} else {
    Write-Output "Warning: No authorized applications specified. All installed apps will be considered unauthorized."
    @()  # Empty array if no authorized apps are listed
}

# Get list of installed applications
$InstalledApps = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | 
    ForEach-Object { Get-ItemProperty $_.PsPath } | 
    Where-Object { $_.DisplayName -and ($_.SystemComponent -ne 1) } |
    ForEach-Object { 
        ($_.DisplayName -replace '[^a-zA-Z0-9]', '').ToLower()
    }

# Compare installed applications with authorized list
$UnauthorizedApps = $InstalledApps | Where-Object { $_ -notin $AuthorizedApps }

if ($UnauthorizedApps) {
    Write-Output "ALERT: Unauthorized Applications:"
    $UnauthorizedApps | ForEach-Object { Write-Output $_ }
    exit 1
} else {
    Write-Output "No unauthorized applications detected."
    exit 0
}
