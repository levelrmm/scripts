<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Send a message to the logged in user using a Windows native 
    notification 
    
    Uses the following PowerShell Modules:
    https://github.com/Windos/BurntToast - Toast Library
    https://github.com/KelvinTegelaar/RunAsUser - To run as logged-in user
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Enter the notification message here.
$Message_file = @"
'Hello, Windows updates and system maintenance will be performed tonight, starting at 9pm. Please close all applications at the end of day and leave the PC powered on. Thank you!', 'Your IT Dept - Computer Maintenance Tonight', 'Ok', 'Info'
"@

#Check if a user is logged in.  Can't send a toast to no one!
$LoggedInUser = Get-Process -IncludeUserName -Name explorer | Select-Object -ExpandProperty UserName -Unique
if ($LoggedInUser) {
    "$LoggedInUser is logged in.  Sending toast"
}
else {
    "No one is logged in.  Exiting..."
    Exit 1
}   

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Check for NuGet on the device and install if not present
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
if (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue) {
    Write-Host "NuGet Package already exists"
}
else {
    Write-host "Installing NuGet"
    Install-PackageProvider -Name NuGet -force
}   

#Check for dependent modules and install if not present
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
$ModuleList = "RunAsUser"
foreach ($Module in $ModuleList) {
    if (Get-Module -ListAvailable -Name $Module -ErrorAction SilentlyContinue) {
        Write-Host "$Module module already exists"
    } 
    else {
        Write-Host "$Module does not exist. Installing"
        Install-Module -Name $Module -Force
    }
}

$TempFolder = 'C:\temp'
if (Test-Path -Path $TempFolder -ErrorAction SilentlyContinue) {
}
else {
    mkdir c:\temp
}

#Save the message to a file because can't pass variables to the invoke-ascurrentuser
#Converting the script block to a string and expanding the variable doesn't work either.  :eyeroll:
$Message_file | Out-File -FilePath $TempFolder\message.txt -Force

invoke-ascurrentuser -scriptblock {
    $TempFolder = 'C:\temp'
    #Read in the message file.
    $message = Get-Content -Path $TempFolder\message.txt
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show($message)
}

Start-Sleep 3
#Delete the message file
Remove-Item $TempFolder\message.txt -Force