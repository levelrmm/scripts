<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Download diskspd and run a disk performance benchmark.  Notify if the 
    latency or MB/s are now performing well.  Thresholds are currently set
    to:

    Latency < 20 ms
    MB/s    < 1000 MB/s

    The default test paramaters are:

    -d60 (run test for 60 seconds)
    -t2 (2 threads)
    -c128M (Create a 128MB file)
    -L (also measure latency statistics)
    -r (random I/O)
    -Sh (Disable both software caching and hardware write caching)
    -w50 (50% write and read)
    
    This can probably be improved to loop through various block sizes and
    and other variations, but this will provide a good quick check.
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

#Need at least PowerShell version 5 for Expand-Archive
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Output "This script requires PowerShell version 5 or above."
    exit 1
}

#Check for free disk space to download the app and to run the test. (A 128MB file is created for the test)
$FreeSpace = get-volume (get-location).Drive.Name | select -ExpandProperty SizeRemaining
if ($FreeSpace -le 250000000) {
    Write-Host "Not enough space on the disk to run the disk performance test"
    exit 1
}

function RunApp() {
    write-host "Running the test for 60 seconds." -ForegroundColor Green
    $AppOutput = & $AppFullPath -d60 -t2 -c128M -L -r -w50 $TempFolder"disk-speed-test.dat" #| Tee-Object -Variable AppOutput

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
        <#  Do we really need the total?  The focus should be on read/write individually because one can be great and the other poor
        ,
        @{
            'Type'    = "Total"
            'Latency' = [decimal]$TotalValues[4].Trim()
            'MBsec'   = [int]$TotalValues[2].Trim()
            'IOPS'    = [int]$TotalValues[3].Trim()
        }
        #>
    )
    $IOResults = $itemsToAdd | ForEach-Object {
        [PSCustomObject]$_
    }
    
    #Print results
    $IOResults | Select-Object Type, Latency, MBsec, IOPS | format-table -AutoSize

    #Alert on poor performance
    foreach ($Latency in $IOResults.Latency) {
        if ($Latency -ge 20) {
            Write-host -ForegroundColor red "The latency of $Latency ms is high.  Disk performance should be investigated."
            $BadPerformance = 1
        }
    }
    foreach ($MBsec in $IOResults.MBsec) {
        if ($MBsec -le 1000) {
            Write-host -ForegroundColor red "The throughput of $MBsec MB/s is low.  Disk performance should be investigated"
            $BadPerformance = 1
        }
    }
    #Delete the temp test file 
    Remove-Item $TempFolder"disk-speed-test.dat" -force
   
    if ($BadPerformance) {
        exit 1
    }
}

#Check for temp path
if (Test-Path -Path $TempFolder -ErrorAction SilentlyContinue) {
}
else {
    mkdir $TempFolder
}

#Check if the file exists
if (Test-Path -path $AppFullPath -ErrorAction SilentlyContinue) {
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
        Invoke-WebRequest -uri $BaseURL$File -outfile $TempFolder$File
        $FileSize = [math]::round((Get-Item -Path $TempFolder$File).Length / 1MB, 2)
        "Downloaded $File - $FileSize MB"
    }
    
    #Unzip the file and run the app
    Expand-Archive -Path $TempFolder$File -DestinationPath $TempFolder$AppName
    RunApp
}