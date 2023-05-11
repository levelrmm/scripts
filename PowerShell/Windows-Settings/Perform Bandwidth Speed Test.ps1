<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Download the Ookla speedtest app and run a speedtest
    https://www.speedtest.net/apps/cli
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

$TempFolder = 'C:\temp\'
if (Test-Path -Path $TempFolder -ErrorAction SilentlyContinue) {
}
else {
    mkdir c:\temp
}

$SpeedTestEXE = $TempFolder + "SpeedTest\speedtest.exe"

function RunTest() {
    & $SpeedTestEXE --accept-license
}

#check if file exists
if (Test-Path -path $SpeedTestEXE -ErrorAction SilentlyContinue) {
    Write-Host "Starting speed test" -ForegroundColor Green
    RunTest
}
else {
    Write-Host "SpeedTest doesn't exist, starting file download"
    #Setup download
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'
    $BaseURL = "https://install.speedtest.net/app/cli/"
    $App = "ookla-speedtest-1.2.0-win64.zip"
    #If multiple files are needed, enter them comma separated. 
    $ListOfFiles = $App
    #Download file(s) to temp folder
    foreach ($File in $ListOfFiles) {
        Invoke-WebRequest -uri $BaseURL$File -outfile $TempFolder$File
        $FileSize = [math]::round((Get-Item -Path $TempFolder$File).Length / 1MB, 2)
        "Downloaded $File - $FileSize MB"
    }
    #Unzip the file
    Expand-Archive -Path $TempFolder$File -DestinationPath $TempFolder"SpeedTest"
    RunTest
}
