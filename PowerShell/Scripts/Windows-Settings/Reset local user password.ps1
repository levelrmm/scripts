<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Change a local user account password.
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Add the username and password here
$UserName = "adns"
$Password = "JustATest123!!!"

#Check if the account is present and if so, set the password.
$checkUser = Get-LocalUser -Name $UserName
if ($checkUser) {
    $Password = convertto-securestring $Password -asplaintext -force
    Write-Host "The user account $UserName exists.  Setting the new password."
    Set-LocalUser -Name $UserName -Password $Password
}
else {
    Write-host "The user account is not present.  Exiting."
    exit 1
}

#Verify that the password was changed by checking the password set timestamp 
$PasswordResetDate = Get-LocalUser -Name $UserName | select -ExpandProperty PasswordLastSet
$CurrentDate = Get-Date
$TimeDiff = New-TimeSpan -start $PasswordResetDate -End $CurrentDate
if ($TimeDiff.Minutes -le 3) {
    Write-Host "Password was successfully changed for $UserName"
}
else {
    Write-host "Something went wrong.  The password was not changed."
    Exit 1
}