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
    600
.LINK
#>


$TestWinget = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq "Microsoft.DesktopAppInstaller" }

#Check if Winget is installed
If ([Version]$TestWinGet. Version -gt "2022.506.16.0") {
    Write-Host "WinGet is Installed, checking environment path." -ForegroundColor Green

    #Find the Winget path, and peel off winget.exe
    $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
    if ($null -eq $ResolveWingetPath) {
        write-host "ERROR: Winget path was not found."
        exit 1
    }
    $WingetPath = $ResolveWingetPath[-1].Path
    $WingetPath = Split-Path -Path $WingetPath -Parent
    
    #Check if Winget is in the system environment path
    If ([Environment]::GetEnvironmentVariable("PATH", "Machine") -like "*$WingetPath*") {
        Write-Host "WinGet path is correct, updating apps as SYSTEM" -ForegroundColor Green
        #Upgrade all apps as system
        try {
            & winget.exe upgrade --all --silent --accept-source-agreements
        }
        catch {
            Write-Host $_.Exception.Message -ForegroundColor Red
            Write-Host "Has the computer been rebooted since adding Winget to the System path variable? Attempting to upgrade via the absolute path."
            & $WingetPath\winget.exe upgrade --all --silent --accept-source-agreements
        }  
    }
    Else {
        #Add Winget to the System path environment variable for future use
        $SystemPath = [Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + $WingetPath
        [Environment]::SetEnvironmentVariable( "Path", $SystemPath, "Machine" )
        
        #Update all apps by calling winget via the full path
        & $WingetPath\winget.exe upgrade --all --silent --accept-source-agreements --accept-source-agreements
    }
}
Else {
    Write-Host "Winget is not installed. Exiting..."
    exit 1
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

Write-Host "Running remaining winget updates as $LoggedInUser"
#write the output to a file so that we can pick it back up as SYSTEM
$UpdateAllApps = { winget upgrade --all --silent --accept-source-agreements --accept-source-agreements | Out-File "$TempFolder\wingetAsUser.txt" }
invoke-ascurrentuser -scriptblock $UpdateAllApps
#Write the contents of the command output file
Get-Content "$TempFolder\wingetAsUser.txt"
#Delete the output file
remove-item "$TempFolder\wingetAsUser.txt" -Force
