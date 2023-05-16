<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Download diskspd and run a disk performance benchmark
    The default test paramaters are:

    -d60 (run test for 60 seconds)
    -t2 (2 threads)
    -c512M (Create a 512MB file)
    -L (also measure latency statistics)
    -r (random I/O)
    -Sh (Disable both software caching and hardware write caching)
    -w50 (50% write and read)
    
    Details on all the paramaters can be found here: https://github.com/Microsoft/diskspd/wiki/Command-line-and-parameters

.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

$AppExecutable = "diskspd.exe"
$AppName = $AppExecutable.split(".")[0]
$TempFolder = 'C:\temp\'
$AppFullPath = $TempFolder + $AppName + "\amd64" + "\$AppExecutable"

function RunApp() {
    write-host "Running the test for 60 seconds." -ForegroundColor Green
    $AppOutput = & $AppFullPath -d60 -t2 -c512M -L -r -w50 $TempFolder"disk-speed-test.dat" #| Tee-Object -Variable AppOutput

    #Convert the output to an array.  (Using regex kept losing formatting)
    $lines = $AppOutput -split "`r`n"

    #Select the lines that contain the read, write, and totals 
    $ReadIO = $lines.IndexOf("Read IO") + 6
    $WriteIO = $lines.IndexOf("Write IO") + 6
    $TotalIO = $lines.IndexOf("Total IO") + 6
    #Break up the lines with the | as a delimiter
    $ReadValues = $lines[$ReadIO].Split('|').Trim()
    $WriteValues = $lines[$WriteIO].Split('|').Trim()
    $TotalValues = $lines[$TotalIO].Split('|').Trim()

    #Push all values into a new PScustomObject
    $itemsToAdd = @(
        @{
            'Type'    = "Read"
            'Latency' = $ReadValues[4].Trim()
            'MiB/s'   = $ReadValues[2].Trim()
            'IOPS'    = $ReadValues[3].Trim()
        },
        @{
            'Type'    = "Write"
            'Latency' = $WriteValues[4].Trim()
            'MiB/s'   = $WriteValues[2].Trim()
            'IOPS'    = $WriteValues[3].Trim()
        },
        @{
            'Type'    = "Total"
            'Latency' = $TotalValues[4].Trim()
            'MiB/s'   = $TotalValues[2].Trim()
            'IOPS'    = $TotalValues[3].Trim()
        }
    )
    $IOResults = $itemsToAdd | ForEach-Object {
        [PSCustomObject]$_
    }
    
    #Print results
    $IOResults

    #Alert on poor performance
    foreach ($Items in $IOResults.Latency) {
        if ($Items -ge 20) {
            Write-host -ForegroundColor red "The latency of $Items ms is high.  Please check the storage on this device"
        }
        else {
            #Write-host -ForegroundColor green "The latency of $Items ms is good" 
        }
    }
}

if (Test-Path -Path $TempFolder -ErrorAction SilentlyContinue) {
}
else {
    mkdir $TempFolder
}

#Check if the file exists
if (Test-Path -path $AppFullPath -ErrorAction SilentlyContinue) {
    Write-Host "Running the test for 60 seconds." -ForegroundColor Green
    RunApp
}
else {
    Write-Host "$AppName doesn't exist, starting file download"
    
    #Setup download
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'
    $BaseURL = "https://github.com/microsoft/diskspd/releases/download/v2.0.21a/"
    $Download = "DiskSpd.zip"
    
    #If multiple files are needed, enter them comma separated. 
    $ListOfFiles = $Download
    
    #Download file(s) to temp folder
    foreach ($File in $ListOfFiles) {
        Invoke-WebRequest -uri $BaseURL$File -outfile $TempFolder$File
        $FileSize = [math]::round((Get-Item -Path $TempFolder$File).Length / 1MB, 2)
        "Downloaded $File - $FileSize MB"
    }
    
    #Unzip the file
    Expand-Archive -Path $TempFolder$File -DestinationPath $TempFolder$AppName
    RunApp
}
