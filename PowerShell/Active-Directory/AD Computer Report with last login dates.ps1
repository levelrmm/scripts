<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    List all enabled users in Active Directory, ordered by last login time. 
    Useful for finding stale active accounts that should be disabled. If 
    the last login field is blank it means the account has never logged
    in.

    Keep in mind that service accounts are only logged in when the service
    starts.  If a service is running for 90-days straight, then the last
    login will be 90 days ago.

.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

Get-ADUser -Filter {(Enabled -eq $true)} -Properties LastLogonDate | select samaccountname, Name, LastLogonDate | Sort-Object LastLogonDate
