<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
   This will install WMF 5.1 on Server 2012 and Server 2012 R2.  This will
   upgrade Powershell to 5.1 as well.

.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

$osVersion = (Get-WMIObject win32_operatingsystem) | Select -ExpandProperty Version

#Server 2012
if ($osVersion -eq "6.2.9200") {
    Write-Host "Running Server 2012"
    $BaseURL = "https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/"
    $Download = "W2K12-KB3191565-x64.msu"
}
#Server 2012 R2
elseif ($osVersion -eq "6.3.9200" -or $osVersion -eq "6.3.9600") {
    Write-Host "Running Server 2012 R2"
    $BaseURL = "https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/"
    $Download = "Win8.1AndW2K12R2-KB3191564-x64.msu"
}
else {
    Write-Host "This script is only meant for Windows Server 2012 and 2012 R2"
    exit 1
}

#Check if already running Powershell version 5 or higher.
if ($PSVersionTable.PSVersion.Major -ge 5) {
    Write-Output "This device is already running PowerShell version 5 or above."
    exit 0
}

#Check for free disk space
$FreeSpace = get-volume (get-location).Drive.Name | select -ExpandProperty SizeRemaining
if ($FreeSpace -le 250000000) {
    Write-Host "Not enough space on the disk"
    exit 1
}

#Check for temp path
$TempFolder = 'C:\temp\'
if (Test-Path -Path $TempFolder -ErrorAction SilentlyContinue) {
}
else {
    mkdir $TempFolder
}

#Setup download
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

    
#If multiple files are needed from the same base URL, enter them comma separated. 
$ListOfFiles = $Download
    
#Download file(s) to temp folder and report on size
foreach ($File in $ListOfFiles) {
    Invoke-WebRequest -uri $BaseURL$File -outfile $TempFolder$File
    $FileSize = [math]::round((Get-Item -Path $TempFolder$File).Length / 1MB, 2)
    "Downloaded $File - $FileSize MB"
}

& wusa.exe "$TempFolder$File" /quiet /norestart
start-sleep 10
Write-Host "The computer must be rebooted in order for the new version of PowerShell to be installed."