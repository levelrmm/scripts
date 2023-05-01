<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Add a local user account and add it to the local administrators group
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Add the username, password, and user description here
$UserName = "INSERT_USERNAME_HERE"
$Password = "INSERT_PASSWORD_HERE"
$Description = "INSERT_DESCRIPTION_HERE"

#Print out the list of enabled local accounts
Get-LocalUser | Where-Object {$_.Enabled -eq 'True'}

#If the account already exists, exit.
$checkUser = Get-LocalUser | Where-Object {$_.Name -eq $UserName} 
if($checkUser){
    Write-Host "The user account $UserName already exists."
    exit 1
}

#Create the account
$Password = convertto-securestring $Password -asplaintext -force
New-LocalUser "$UserName" -Password $Password -Description $Description
Add-LocalGroupMember -Group "Administrators" -Member "$UserName"
