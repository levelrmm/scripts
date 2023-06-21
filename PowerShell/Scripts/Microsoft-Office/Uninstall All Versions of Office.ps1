<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    This may take a few minutes to run completely depending on the speed
    of the machine.  Reboot after running as well because the icons might
    linger otherwise. 
      
    Warning - this will remove all Office products including Visio, 
    Project, etc!
    
    This is a combination of the M365 uninstaller and the legacy Office 
    installer found here: https://github.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/tree/master/Office-ProPlus-Deployment/Remove-PreviousOfficeInstalls
.LANGUAGE
    PowerShell
.TIMEOUT
    1200
.LINK
#>


Set-ExecutionPolicy RemoteSigned -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$TempFolder = 'C:\temp\UninstallOffice\'
if (Test-Path -Path $TempFolder) {
    #Temp path exists
}
else {
    mkdir $TempFolder
}

Write-Host "Downloading all required files"
$BaseURL = "https://github.com/levelsoftware/scripts/raw/main/PowerShell/Microsoft-Office/Uninstall All Versions of Office/"
$O365Setup = "OfficeSetup.exe"
$ConfigFile = "UninstallOffice.xml"
$ListOfFiles = $O365Setup, $ConfigFile, "OffScrub03.vbs", "OffScrub07.vbs", "OffScrub10.vbs", "OffScrub_O15msi.vbs", "OffScrub_O16msi.vbs", "OffScrubc2r.vbs", "Office2013Setup.exe", "Office2016Setup.exe", "Remove-PreviousOfficeInstalls.ps1"
foreach ($File in $ListOfFiles) {
    iwr -uri $BaseURL$File -outfile $TempFolder$File
    $FileSize = [math]::round((Get-Item -Path $TempFolder$File).Length / 1MB, 2)
    "Downloaded $File - $FileSize MB"
}

"Attempting to uninstall Office 365 with the primary setup.exe"
#Set-PSDebug -Trace 1
Start-Process -Filepath "$TempFolder$O365Setup" -Wait -ArgumentList "/configure $TempFolder$ConfigFile" -PassThru

"Attempting to uninstall any legacy Office installs"
Start-Process powershell -argument $TempFolder"Remove-PreviousOfficeInstalls.ps1" -Wait -PassThru

"Parsing the registry for `"Microsoft 365`" and running the uninstallers"
$OfficeUninstallStrings = ((Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*") `
        + (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*") | 
    Where { $_.DisplayName -like "*Microsoft 365*" } | 
    Select UninstallString).UninstallString

ForEach ($UninstallString in $OfficeUninstallStrings) {
    $UninstallEXE = ($UninstallString -split '"')[1]
    $UninstallArg = ($UninstallString -split '"')[2] + " DisplayLevel=False"
    Start-Process -FilePath $UninstallEXE -ArgumentList $UninstallArg -Wait -PassThru
}