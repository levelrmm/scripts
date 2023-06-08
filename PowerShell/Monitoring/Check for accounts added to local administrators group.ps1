<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Check for events when users have been added to the local administrators
    group
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>


#Check if security audit logging for "Security Group Management" is enabled
#Please note that this is better edited via group policy instead of local policy because group policy could overwrite this!
$AuditLoggingStatus = auditpol.exe /get '/subcategory:{0CCE9237-69AE-11D9-BED3-505054503030}'
if ($AuditLoggingStatus -like "*No Auditing*") {
    #Enable security audit logging for "Security Group Management" 
    auditpol.exe /set '/subcategory:{0CCE9237-69AE-11D9-BED3-505054503030}' /success:enable
}

#Check the security event log for event 4732 where the group name is "Administrators"
$EventLogResults = Get-WinEvent -LogName Security -FilterXPath @'
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[
        EventID=4732 and
        TimeCreated[timediff(@SystemTime) &lt;= 604800000]]] and
        *[EventData[Data[@Name="TargetDomainName"]='BUILTIN']] and
        *[EventData[Data[@Name='TargetUserName']='Administrators']]
    </Select>
  </Query>
</QueryList>
'@

#If the event exists, return "Change!" for the Level script-based monitor to alert
if ($EventLogResults.Id -eq 4732) {
    Write-Host "Change!"
}