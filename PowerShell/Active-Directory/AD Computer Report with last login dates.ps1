<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    List all Computers in Active Directory, ordered by last login time. 
    Useful for finding stale computers that should be removed.

.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>


Get-ADComputer -Filter  {OperatingSystem -Like '*' } -Properties lastlogondate,operatingsystem |select name,lastlogondate,operatingsystem | Sort-Object lastlogondate