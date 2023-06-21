<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Create a GPO that will auto deploy the Level agent to all computers
    in the domain.  This should be run only once on a single domain 
    controller.

    See our help docs and video explaination here:
    https://docs.level.io/1.0/admin-guides/installing-level-agents/windows/install-agents-via-group-policy

.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#IMPORTANT: Paste your Level install command from https://app.level.io/devices "Install New Agent" below on line 48

# Check for Active Directory and halt if not present
$service = Get-Service -Name ntds -ErrorAction SilentlyContinue
if($null -eq $service)
{
    Write-Error "This computer is not a domain controller.  Please run this script on a domain controller."
} else {
#Check if using c:\windows\sysvol or c:\windows\sysvol_dfsr
if (Test-Path -Path c:\windows\sysvol_dfsr) {
    "Using Sysvol_DFSR"
     $Sysvol = "sysvol_dfsr"
} else {
    "Using Sysvol"
	$Sysvol = "sysvol"
}
# Create the Level logon script in \$Sysvol\domain\scripts\Install_Level_Agent.ps1
$Net_Share_Path = $env:systemroot + "\$Sysvol\domain\scripts\Install_Level_Agent.ps1"
Set-Content $Net_Share_Path @'
# Check if the Level service is already present 
$service = Get-Service -Name Level -ErrorAction SilentlyContinue
$hostname = hostname
New-EventLog -LogName Application -Source "Level"
if($service -eq $null) {
    # Level is not installed. Paste your install script from the Level app below so it can be installed
    ########### PASTE LEVEL INSTALL STRING BELOW ##############
Paste Level install command here
    ########### PASTE LEVEL INSTALL STRING ABOVE ##############

    Write-EventLog -LogName "Application" -Source "Level" -EventID 100 -EntryType Information -Message "Level was successfully installed.  Please check the agent page at https://app.level.io and look for the agent called $hostname"
} else {
    # Level is already installed, halt.
    Write-EventLog -LogName "Application" -Source "Level" -EventID 101 -EntryType Information -Message "The Level install GPO ran successfully, but Level is already installed.  Look for the agent called $hostname"
}
'@

# Create the group policy backup folders and files prior to importing 
    $GPO_path = $env:systemdrive + '\temp\Level-Temp\{920B8A43-A054-4C44-B126-1E057DFFBC4C}\DomainSysvol\GPO\Machine\Preferences\ScheduledTasks'
    New-Item $GPO_path -ItemType Directory

# Create Backup.xml
    $DomainName = Get-ADDomain | Select-Object -ExpandProperty Forest
    $Backup_xml_path = $env:systemdrive + '\temp\Level-Temp\{920B8A43-A054-4C44-B126-1E057DFFBC4C}\Backup.xml'
    Set-Content $Backup_xml_path @"
<?xml version="1.0" encoding="utf-8"?>
<GroupPolicyBackupScheme bkp:version="2.0" bkp:type="GroupPolicyBackupTemplate" xmlns:bkp="http://www.microsoft.com/GroupPolicy/GPOOperations" xmlns="http://www.microsoft.com/GroupPolicy/GPOOperations">
<GroupPolicyObject><FilePaths/><GroupPolicyCoreSettings><ID><![CDATA[{ADF3CB7A-D977-4F44-9D77-DCAC28426AC2}]]></ID><Domain></Domain><SecurityDescriptor></SecurityDescriptor><DisplayName><![CDATA[Level Install - Task]]></DisplayName><Options><![CDATA[0]]></Options><UserVersionNumber><![CDATA[0]]></UserVersionNumber><MachineVersionNumber><![CDATA[1835036]]></MachineVersionNumber><MachineExtensionGuids><![CDATA[[{00000000-0000-0000-0000-000000000000}{CAB54552-DEEA-4691-817E-ED4A4D1AFC72}][{AADCED64-746C-4633-A97C-D61349046527}{CAB54552-DEEA-4691-817E-ED4A4D1AFC72}]]]></MachineExtensionGuids><UserExtensionGuids/><WMIFilter/></GroupPolicyCoreSettings> 
    <GroupPolicyExtension bkp:ID="{F15C46CD-82A0-4C2D-A210-5D0D3182A418}" bkp:DescName="Unknown Extension">
    <FSObjectFile bkp:Path="%GPO_MACH_FSPATH%\Preferences\ScheduledTasks\ScheduledTasks.xml" bkp:Location="DomainSysvol\GPO\Machine\Preferences\ScheduledTasks\ScheduledTasks.xml"/>
    </GroupPolicyExtension>
    </GroupPolicyObject>
</GroupPolicyBackupScheme>
"@

# Create bkupInfo.xml
    $bkupInfo_xml_path = $env:systemdrive + '\temp\Level-Temp\{920B8A43-A054-4C44-B126-1E057DFFBC4C}\bkupInfo.xml'
    Set-Content $bkupInfo_xml_path @'
    <BackupInst xmlns="http://www.microsoft.com/GroupPolicy/GPOOperations/Manifest"><GPOGuid><![CDATA[{1041B92A-930A-46F9-8942-CA7AB9080D33}]]></GPOGuid><GPODomain><![CDATA[level.local]]></GPODomain><GPODomainGuid><![CDATA[{5ce50db9-5895-43f4-ab58-fb8f5811a29b}]]></GPODomainGuid><GPODomainController><![CDATA[Server.level.local]]></GPODomainController><BackupTime><![CDATA[2022-05-14T21:28:22]]></BackupTime><ID><![CDATA[{920B8A43-A054-4C44-B126-1E057DFFBC4C}]]></ID><Comment><![CDATA[]]></Comment><GPODisplayName><![CDATA[Install Level Agent]]></GPODisplayName></BackupInst>
'@

# Create ScheduledTasks.xml
$ScheduledTasks_xml_path = $env:systemdrive + '\temp\Level-Temp\{920B8A43-A054-4C44-B126-1E057DFFBC4C}\DomainSysvol\GPO\Machine\Preferences\ScheduledTasks\ScheduledTasks.xml'
    Set-Content $ScheduledTasks_xml_path @"
<?xml version="1.0" encoding="utf-8"?>
<ScheduledTasks clsid="{CC63F200-7309-4ba0-B154-A71CD118DBCC}">
    <ImmediateTaskV2 clsid="{9756B581-76EC-4169-9AFC-0CA8D43ADB5F}" name="Install Level Agent" image="0" changed="2022-05-18 04:29:29" uid="{F734F614-77C6-4DFA-B0B0-25D49EE2FE35}" userContext="0" removePolicy="0">
        <Properties action="C" name="Install Level Agent" runAs="NT AUTHORITY\System" logonType="S4U">
            <Task version="1.3">
                <RegistrationInfo>
                    <Author>LEVEL\Administrator</Author>
                    <Description/>
                </RegistrationInfo>
                <Principals>
                    <Principal id="Author">
                        <UserId>NT AUTHORITY\System</UserId>
                        <LogonType>S4U</LogonType>
                        <RunLevel>HighestAvailable</RunLevel>
                    </Principal>
                </Principals>
                <Settings>
                    <IdleSettings>
                        <Duration>PT5M</Duration>
                        <WaitTimeout>PT1H</WaitTimeout>
                        <StopOnIdleEnd>false</StopOnIdleEnd>
                        <RestartOnIdle>false</RestartOnIdle>
                    </IdleSettings>
                    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
                    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
                    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
                    <AllowHardTerminate>true</AllowHardTerminate>
                    <StartWhenAvailable>true</StartWhenAvailable>
                    <AllowStartOnDemand>true</AllowStartOnDemand>
                    <Enabled>true</Enabled>
                    <Hidden>false</Hidden>
                    <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
                    <Priority>7</Priority>
                    <DeleteExpiredTaskAfter>PT0S</DeleteExpiredTaskAfter>
                </Settings>
                <Triggers>
                    <TimeTrigger>
                        <StartBoundary>%LocalTimeXmlEx%</StartBoundary>
                        <EndBoundary>%LocalTimeXmlEx%</EndBoundary>
                        <Enabled>true</Enabled>
                    </TimeTrigger>
                </Triggers>
                <Actions Context="Author">
                    <Exec>
                        <Command>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Command>
                        <Arguments>-ExecutionPolicy bypass -command "&amp; \\$DomainName\SYSVOL\$DomainName\scripts\Install_Level_Agent.ps1"</Arguments>
                    </Exec>
                </Actions>
            </Task>
        </Properties>
    </ImmediateTaskV2>
</ScheduledTasks>
"@

# Create a new GPO "Install Level Agent" and link it to the root of the domain
$DistinguishedName = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName
New-GPO -Name "Install Level Agent" | New-GPLink -Target $DistinguishedName

# Import the GPO settings from the backup files (above) into the new GPO
$GPO_Backup_Location = $env:systemdrive + '\temp\Level-Temp\'
Import-GPO -BackupGpoName "Install Level Agent" -Path $GPO_Backup_Location -TargetName "Install Level Agent"
}