<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Use winget to update all 3rd party apps that winget is capable of 
    managing.  This will be run both as SYSTEM and as the logged in user.
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>


$TestWinget = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq "Microsoft.DesktopAppInstaller" }
$TestEnvPath = [Environment]::GetEnvironmentVariable("PATH", "Machine") -notlike "*C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe*"
#Check if Winget is installed
If ([Version]$TestWinGet. Version -gt "2022.506.16.0") {
    Write-Host "WinGet is Installed, checking environment path." -ForegroundColor Green

    #Check if Winget is in the system environment path
    If ($TestEnvPath) {
        Write-Host "WinGet path is correct, updating apps as SYSTEM" -ForegroundColor Green
        #Upgrade all apps as system
        winget upgrade --all --silent --accept-source-agreements
    }
    Else {
        #Add Winget to the System path environment variable for future use
        $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
        if ($ResolveWingetPath) {
            $WingetPath = $ResolveWingetPath[-1].Path
        }
        $Wingetpath = Split-Path -Path $WingetPath -Parent

        #Set system path environment variable
        $SystemPath = [Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + $Wingetpath
        [Environment]::SetEnvironmentVariable( "Path", $SystemPath, "Machine" )
        
        #Update all apps by calling winget via the full path
        & $WingetPath\winget.exe upgrade --all --silent --accept-source-agreements
    }
}
Else {
    Write-Host "Winget is not installed. Exiting..."
    exit
}


#Check if a user is logged in.  If so, rerun upgrade all command within the session so apps in the user space are also updated
$LoggedInUser = Get-Process -IncludeUserName -Name explorer -ErrorAction SilentlyContinue | Select-Object -ExpandProperty UserName -Unique
if ($LoggedInUser) {
    "$LoggedInUser is logged in."
}
else {
    "No one is logged in, so no need to rerun updates in the user space.  Exiting..."
    exit
}   

#Check for dependent modules and install if not present. (NuGet)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$PackageProviderList = "NuGet"
foreach ($PackageProvider in $PackageProviderList) {
    if (Get-PackageProvider -ListAvailable -Name $PackageProvider -ErrorAction SilentlyContinue) {
        Write-Host "$PackageProvider module already exists"
    } 
    else {
        Write-Host "$PackageProvider does not exist. Installing"
        Install-PackageProvider -Name $PackageProvider -Force
    }
}
#Check for dependent modules and install if not present (RunAsUser)
$ModuleList = "RunAsUser"
foreach ($Module in $ModuleList) {
    if (Get-Module -ListAvailable -Name $Module) {
        Write-Host "$Module module already exists"
    } 
    else {
        Write-Host "$Module does not exist. Installing"
        Install-Module -Name $Module -Force -AllowClobber 
    }
}

invoke-ascurrentuser -scriptblock {
    winget upgrade --all --silent --accept-source-agreements
}
