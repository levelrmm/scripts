<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Install Microsoft Visio Pro 2021 Retail.  For M365 Visio Plan 2
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>


Set-ExecutionPolicy RemoteSigned -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Check for a temp path and create if not there
$TempFolder = 'C:\temp'
if (Test-Path -Path $TempFolder) {
    #Temp path exists
} else {
	mkdir $TempFolder
}

#Download the required files
"Downloading all required files"
$ProgressPreference = 'SilentlyContinue'
$BaseURL = "https://github.com/levelsoftware/scripts/raw/main/PowerShell/Microsoft-Office/Install Visio Pro 2021 Retail (365) (64-bit)/"
$O365Setup = "VisioSetup.exe"
$ConfigFile = "VisioPro2021Retail-x64.xml"
$ListOfFiles = $O365Setup,$ConfigFile
foreach($File in $ListOfFiles)
{
    iwr -uri $BaseURL$File -outfile $TempFolder\$File
    $FileSize = [math]::round((Get-Item -Path $TempFolder\$File).Length/1MB,2)
    "Downloaded $File - $FileSize MB"
}

$Installer = "$TempFolder\$O365Setup"
$ConfigFile = "$TempFolder\$ConfigFile"

#Install the application
& $Installer /configure $ConfigFile
