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
# Name: Windows Monitor - Check admin groups against trust list
# Description: This script pulls users from the administrators group, or if
# a domain controller the "domain admins" group.  These users are compared
# with a trust list of user accounts and if accounts exist that are not in the
# list, then an alert message it generated.
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
# Run frequency: Hours
# Duration: 1
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# Enter the list of approved admin accounts.  Wildcards are acceptable "*"

# Trusted domain admin accounts
$domainAdminsList = "administrator", "itadmin", "secondaryadmin"

# Trusted local admin accounts
$localAdminsList = "*Domain Admins", "*administrator"
# -----------------------------------------------------------------------------

# Check if the device is a domain controller, and if so check Active Directory "Domain Admins"
$domainController = (Get-WmiObject -Query "SELECT * FROM Win32_ComputerSystem").DomainRole -in 4, 5
if ($domainController) {
    # Import the Active Directory module
    Import-Module ActiveDirectory

    # Get the members of the "Domain Admins" group
    $actualAdmins = Get-ADGroupMember -Identity "Domain Admins" | Select-Object -ExpandProperty SamAccountName
    $adminsList = $domainAdminsList
    $accountType = "Domain"    
} 
else {
    # This device is not a domain controller. Check local accounts
    $actualAdmins = Get-LocalGroupMember -Group "Administrators" | Select-Object -ExpandProperty Name
    $adminsList = $localAdminsList
    $accountType = "Local"
}

$badAdmins = @()
$goodAdmins = @()

#Compare the admin accounts vs the adminsList, and if an account exists then add it to $badAdmins
$actualAdmins | ForEach-Object {
    $adminName = $_
    $matchFound = $false
    foreach ($account in $adminsList) {
        if ($adminName -like $account) {
            $matchFound = $true
            break
        }
    }
    if (-not $matchFound) {
        $badAdmins += $adminName
    }
    else {
        $goodAdmins += $adminName
    }
}

if ($badAdmins.count -gt 0) {
    Write-Output "ALERT: The $accountType Admins group contains non-standard accounts!"
    $badAdmins
    exit 1
}
else {
    Write-Output "Good news!  The $accountType Admins group only contains these approved users:"
    $goodAdmins
    exit
}
