# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Monitor - Check Disk Performance
# Description: Download diskspd and run a disk performance benchmark. Notify
# if the latency or MB/s are not performing well.
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Check Disk Performance
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 24
# -----------------------------------------------------------------------------

$AppExecutable = "diskspd.exe"
$AppName = $AppExecutable.Split(".")[0]
$TempFolder = 'C:\temp\'
$AppFullPath = Join-Path -Path (Join-Path -Path $TempFolder -ChildPath $AppName) -ChildPath "amd64\$AppExecutable"

#Need at least PowerShell version 5 for Expand-Archive
if ($PSVersionTable.PSVersion.Major -lt 5) {
    #Write-Output "This script requires PowerShell version 5 or above."
    exit 1
}

#Check for free disk space to download the app and to run the test. (A 128MB file is created for the test)
$FreeSpace = (Get-Volume -DriveLetter (Get-Location).Drive.Name).SizeRemaining
if ($FreeSpace -le 250000000) {
    #Write-Host "Not enough space on the disk to run the disk performance test"
    exit 1
}

function RunApp {
    #write-host "Running the test for 60 seconds." -ForegroundColor Green
    $AppOutput = & $AppFullPath -d60 -t2 -c128M -L -r -w50 (Join-Path -Path $TempFolder -ChildPath "disk-speed-test.dat") #| Tee-Object -Variable AppOutput

    #Convert the output to an array.  (Using regex kept losing formatting)
    #Much of what follows is to preserve formatting and make the output a PowerShell custom object
    $lines = $AppOutput -split "`r`n"

    #Select the lines that contain the read, write, and totals 
    $ReadIO = $lines.IndexOf("Read IO") + 6
    $WriteIO = $lines.IndexOf("Write IO") + 6
    $TotalIO = $lines.IndexOf("Total IO") + 6
    #Break up the lines with the | as a delimiter
    $ReadValues = $lines[$ReadIO].Split('|').Trim()
    $WriteValues = $lines[$WriteIO].Split('|').Trim()
    $TotalValues = $lines[$TotalIO].Split('|').Trim()

    #Push all values into a new PSCustomObject
    $itemsToAdd = @(
        @{
            'Type'    = "Read"
            'Latency' = [decimal]$ReadValues[4].Trim()
            'MBsec'   = [int]$ReadValues[2].Trim()
            'IOPS'    = [int]$ReadValues[3].Trim()
        },
        @{
            'Type'    = "Write"
            'Latency' = [decimal]$WriteValues[4].Trim()
            'MBsec'   = [int]$WriteValues[2].Trim()
            'IOPS'    = [int]$WriteValues[3].Trim()
        }
    )
    $IOResults = $itemsToAdd | ForEach-Object {
        [PSCustomObject]$_
    }
    
    #Print results
    #$IOResults | Select-Object Type, Latency, MBsec, IOPS | Format-Table -AutoSize

    #Alert on poor performance
    $BadPerformance = $false
    foreach ($Result in $IOResults) {
        if ($Result.Latency -ge 20) {
            #Write-host -ForegroundColor Red "The latency of $($Result.Latency) ms is high. Disk performance should be investigated."
            $BadPerformance = $true
        }
        if ($Result.MBsec -le 1000) {
            #Write-host -ForegroundColor Red "The throughput of $($Result.MBsec) MB/s is low. Disk performance should be investigated."
            $BadPerformance = $true
        }
    }

    #Delete the temp test file 
    Remove-Item (Join-Path -Path $TempFolder -ChildPath "disk-speed-test.dat") -Force
   
    if ($BadPerformance) {
        Write-Host "ALERT"
        exit 1
    }
}

#Check for temp path
if (-not (Test-Path -Path $TempFolder -ErrorAction SilentlyContinue)) {
    New-Item -ItemType Directory -Path $TempFolder | Out-Null
}

#Check if the file exists
if (Test-Path -Path $AppFullPath -ErrorAction SilentlyContinue) {
    RunApp
}
else {
    Write-Host "$AppName doesn't exist, starting file download"
    
    #Setup download
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'
    $BaseURL = "https://github.com/microsoft/diskspd/releases/download/v2.0.21a/"
    $Download = "DiskSpd.zip"
    
    #If multiple files are needed from the same base URL, enter them comma separated. 
    $ListOfFiles = $Download
    
    #Download file(s) to temp folder and report on size
    foreach ($File in $ListOfFiles) {
        Invoke-WebRequest -Uri ($BaseURL + $File) -OutFile (Join-Path -Path $TempFolder -ChildPath $File)
        $FileSize = [math]::Round((Get-Item -Path (Join-Path -Path $TempFolder -ChildPath $File)).Length / 1MB, 2)
        "Downloaded $File - $FileSize MB"
    }
    
    #Unzip the file and run the app
    Expand-Archive -Path (Join-Path -Path $TempFolder -ChildPath $Download) -DestinationPath (Join-Path -Path $TempFolder -ChildPath $AppName)
    RunApp
}
