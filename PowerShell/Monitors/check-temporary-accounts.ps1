# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Monitor - Check Temporary Accounts
# Description: Look for possible temporary (test) user accounts that are not disabled
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Check Temporary Accounts
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# List of strings that might indicate a temporary or test account
$ArrayOfNames = @("temp", "test", "tmp", "skykick", "migrat", "migwiz", "dummy", "trial", "lab")

# Function to check if any user accounts are enabled
function CheckUsers {
    foreach ($user in $Users) {
        # Check if the accounts are enabled
        if ($user.Enabled) {
            Write-Host "ALERT"
            Exit
        }
    }
}

# Determine if the device is a domain controller or not
$domainController = (Get-WmiObject -Query "SELECT * FROM Win32_ComputerSystem").DomainRole -in 4, 5

if ($domainController) {
    # This device is a domain controller. Check Active Directory
    foreach ($name in $ArrayOfNames) {
        $filter = "Name -like '*$name*'"
        $Users = Get-ADUser -Filter $filter -Property Enabled
        CheckUsers
    }
} 
else {
    # This device is not a domain controller. Check local accounts
    foreach ($name in $ArrayOfNames) {
        $Users = Get-LocalUser | Where-Object Name -like "*$name*"
        CheckUsers
    }
}
