<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Install one or more apps via Winget.
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Add your app(s) here. For a single app just "App1"
#For multiple apps use "App1", "App2", "App3"
#To easily find app names check https://winstall.app/ or https://winget.run/
$App = "Notepad++.Notepad++", "Google.Chrome"


$TestWinget = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq "Microsoft.DesktopAppInstaller" }
$TestEnvPath = [Environment]::GetEnvironmentVariable("PATH", "Machine") -like "*C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe*"
#Check if Winget is installed
If ([Version]$TestWinGet. Version -gt "2022.506.16.0") {
    Write-Host "WinGet is Installed, checking environment path." -ForegroundColor Green

    #Check if Winget is in the system environment path
    If ($TestEnvPath) {
        Write-Host "WinGet path is correct, installing as SYSTEM" -ForegroundColor Green
        #Install the app
        foreach($AppName in $App){
            Write-Host "Installing $AppName"
            & winget.exe install --exact --id $AppName --silent --accept-package-agreements --accept-source-agreements
        }
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
        
        ##Install the app by calling winget via the full path
        foreach($AppName in $App){
            Write-Host "Installing $AppName"
            & $WingetPath\winget.exe install --exact --id $App --silent --accept-package-agreements --accept-source-agreements
        }

        
    }
}
Else {
    Write-Host "Winget is not installed. Exiting..."
    exit 1
}