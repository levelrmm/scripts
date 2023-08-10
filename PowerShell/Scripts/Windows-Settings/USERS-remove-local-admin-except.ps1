<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Remove all users from the local admins group except for the accounts 
    specified in the User variables
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

$User1 = "Domain Admins"
$User2 = "Administrator"

Get-LocalGroupMember administrators |
where { $_.name -notmatch "$User1|$User2" } |
Remove-LocalGroupMember administrators -Verbose