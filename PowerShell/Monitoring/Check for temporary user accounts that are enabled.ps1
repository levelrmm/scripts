<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Look for possible temporary (test) user accounts that are not disabled
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#List of strings that might indicate a temporary or test account
$ArrayOfNames = @("temp", "test", "tmp", "skykick", "migrat", "migwiz", "dummy", "trial", "lab")

function CheckUsers {
    if ($Users -ne $null) {
        foreach ($user in $Users) {
            #Check if the accounts are enabled
            if ($user.enabled -eq "True") { 
                Write-host "Alert!"
                exit
                
            }
        }
    }
}

if ( Get-WmiObject -Query "select * from Win32_OperatingSystem where ProductType='2'" ) {
    #This device is a domain controller.  Check Active directory
    foreach ($name in $ArrayOfNames) {
        $filter = 'Name -like "*' + $($name) + '*"'
        $Users = Get-ADUser -Filter $filter -Property enabled
        CheckUsers
    }
} 
else {
    #This device is not a domain controller.  Check local accounts
    foreach ($name in $ArrayOfNames) {
        $Users = Get-LocalUser | where name -Like "*$name*"
        CheckUsers
    }
}


