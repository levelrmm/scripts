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
# Name: Windows Monitor - Local Disk Errors
# Description: Checks local disks for errors reported in event viewer within the 
# last 24 hours
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Local Disk Errors
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

$ErrorActionPreference = 'silentlycontinue'
$TimeSpan = (Get-Date) - (New-TimeSpan -Day 1)
if (Get-WinEvent -FilterHashtable @{LogName = 'system'; ID = '11', '9', '15', '52', '129', '7', '98'; Level = 2, 3; ProviderName = '*disk*', '*storsvc*', '*ntfs*'; StartTime = $TimeSpan } -MaxEvents 10 | Where-Object -Property Message -Match Volume*) {
    Write-Output "ALERT"
    Exit 1
}
else {
    Write-Output "Disks are Healthy"
    Exit 0
}
