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
# Name: Windows Monitor - Find inactive AD user accounts
# Description: Search Active Directory for users that have not logged in for 
# some time.  The threshold in days is defined with $InactiveDays.   Not 
# included are user accounts that begin with HealthMailbox, IUSR, IWAM, AAD,
# MSOL, etc.  Also excluding disabled accounts and any with "Audited" in the
# description field.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Find inactive AD user accounts
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 24
# -----------------------------------------------------------------------------

# Define the days threshold for how long an account can be inactive before alerting.
$InactiveDays = 90
$Days = (Get-Date).Adddays(-$InactiveDays)

# Check if the device is a domain controller
$productType = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType
if ($productType -ne 2) {
    Write-Host "Please run this script on a domain controller."
    Exit 1
}

# Get users and apply filters. If the word "audited" is in the description then the account will not show.
# This provides a mechanism to remove service accounts from the report.  We also filter out system accounts
# and disabled accounts. 
$users = Get-ADUser -Filter { Enabled -eq $true } -Properties LastLogonDate, Description |
Where { ($_.LastLogonDate -lt $Days) -or ($_.LastLogonDate -eq $NULL) } |
Where-Object { $_.Description -notlike "*audited*" -and $_.SamAccountName -notmatch '^HealthMailbox|^IUSR_|^IWAM_|^AAD_|^MSOL_' -and $_.Name -notmatch 'HealthMailbox' } |
Sort-Object LastLogonDate

# If no inactive accounts, then exit
if ($null -eq $users) {
    Write-Host "No accounts have been found that have not logged in for $InactiveDays days."
    exit
}

# Print the inactive account report
Write-Host "ALERT: accounts have been found that have not logged in for $InactiveDays days.`n"
$users | Format-Table -AutoSize SamAccountName, Name, @{Name = "LastLogonDate"; Expression = { if ($_.LastLogonDate -eq $null) { "Never logged in" } else { $_.LastLogonDate } } }, DistinguishedName, Description
exit 1
