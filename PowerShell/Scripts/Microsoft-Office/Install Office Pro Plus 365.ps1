<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Install Office for the following M365 license types:
        Office 365 Enterprise E3
        Office 365 Enterprise E4
        Office 365 Enterprise E5
        Microsoft 365 E3
        Microsoft 365 E5
        Microsoft 365 Apps for enterprise
.LANGUAGE
    PowerShell
.TIMEOUT
    600
.LINK
#>

#Setup
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$TempFolder = 'C:\temp\'
if (Test-Path -Path $TempFolder) {
}
else {
    mkdir c:\temp
}

#Download installers to temp folder
Write-Host "Downloading required files"
$ProgressPreference = 'SilentlyContinue'
$BaseURL = "https://github.com/levelsoftware/scripts/raw/main/PowerShell/Microsoft-Office/Install Office Pro Plus 365/"
$O365Setup = "OfficeSetup.exe"
$ConfigFile = "O365ProPlusRetail-x64.xml"
$ListOfFiles = $O365Setup, $ConfigFile
foreach ($File in $ListOfFiles) {
    iwr -uri $BaseURL$File -outfile $TempFolder$File
    $FileSize = [math]::round((Get-Item -Path $TempFolder$File).Length / 1MB, 2)
    "Downloaded $File - $FileSize MB"
}

#Install Office
& $TempFolder$O365Setup /configure $ConfigFile