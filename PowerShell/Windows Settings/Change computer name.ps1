<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Change the computer name to a name followed by the serial number
    (service tag).  For example "Contoso-ABC1234".  Please note the 
    computer will need to be rebooted in order to take effect.
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Change this to the proper name that will be used to prefix
$ClientName = "CHANGE_ME"
$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber  
$computer = "$ClientName-$SerialNumber"

#Print out the current computer name
"Current hostname is $env:computername"
Rename-Computer -NewName $computer -Force

#Print out the new computer name.
"Hostname changed to $computer"