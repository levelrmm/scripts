# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment.  We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Audit Workstation Standards
# Description: Run a series of checks to determin if a workstation is meeting
# minimum thresholds.  For example, amount of memory, class of CPU, using SSD
# stroage, etc.
#
# Timeout: 300
# Version: 1.0
#
# -----------------------------------------------------------------------------

#Set desired thresholds for standards.
$DesktopOSMinimumVersion = 14393
$PendingUpdates = 20
$RAM_Minimum = 8
$MinimumIntelGeneration = 7  #7th gen core CPUs
$MinimumAmdGeneration = 2000  #2000 series of Ryzen
$FileLimitInMyDocs = 30
$MinimumHorizontalResolution = 1920 
$MinimumVerticalResolution = 1080
$MinimumOutlookVersion = 16  #Outlook 2016, 2019, Outlook 365 and above show as version 16


#get OS version
$OSVer = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty Build

#is the OS version less than $DesktopOSMinimumVersion
if ($OSVer -lt $DesktopOSMinimumVersion) {
    Write-Host "`nALERT: Windows version is less than $DesktopOSMinimumVersion"
    $HasError += 1
}

#Check available Windows Updates
$UpdateList = ((New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher()).Search('IsInstalled=0 and IsHidden=0').updates
$NumberPendingUpdates = $UpdateList.count
if ($NumberPendingUpdates -gt $PendingUpdates) {
    Write-Host "`nALERT: There are $NumberPendingUpdates pending updates that have not been installed."
    $HasError += 1
}

#Check if Windows is activated
$ActivationStatus = Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | where { $_.PartialProductKey } | select -ExpandProperty LicenseStatus
if ($ActivationStatus = 0) {
    Write-Host "`nALERT: Windows is not activated."
    $HasError += 1
}

#Verify RAM is greater than 8GB
$RAM = (Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | select -ExpandProperty Sum) / 1GB
if ($RAM -lt $RAM_Minimum) {
    Write-Host "`nALERT: PC has too little RAM: $RAM GB.`n"
    $HasError += 1
}

#This section checks that the CPU is not older than $MinimumIntelGeneration
$cpuInfo = Get-WmiObject Win32_Processor | Select-Object -ExpandProperty Name
$CPUManufacturer = Get-WmiObject Win32_Processor | Select-Object -ExpandProperty Manufacturer

# Regular expression to extract the model number and generation.  This was built over time by trial and error and can still be improved
$regex = [regex]::Match($cpuInfo, 'i\d{1,2}-\d{1,5}|Pentium|Atom|i3|E-2\d{3}|E3-\d{4}|E5-\d{4}|\d{4} |\d{4}.| \d{3} ')
if ($regex.Success) {
    $cpuModel = $regex.Value
}
else {
    Write-Host "ALERT: Can't determine the CPU model/generation."
    $DisplayCPU += 1
    $HasError += 1
}

# Intel CPU
if ($CPUManufacturer -like "GenuineIntel") {
    # Check for Core generation and model
    if ($cpuModel -match 'i(?!3)\d{1,2}-\d{1,5}') {
        $generationMatch = $cpuModel -split '-' | Select-Object -Last 1
        $generation = $generationMatch -replace '\D'  # Extract and convert digits only
        #If model number is 5 digits long, then the first 2 digits make up the generation.  i7-12700 is 12th gen
        if ($generation.Length -eq 5) {
            $generation = $generation.Substring(0, 2)
        }
        #If the model is 4 digits long, then the first digit is the generation.  i5-7500 is 7th gen.
        else {
            $generation = $generation[0]
        }
        if ([int]$generation -lt $MinimumIntelGeneration) {
            Write-Host "ALERT: The CPU generation is too old."
            $HasError += 1
            $DisplayCPU += 1
        }
    }
    elseif ($cpuModel -match 'E5-\d{4}') {
        #Xeon E5 generation.  Eventually move this into the elseif below
    }
    elseif ($cpuModel -match 'i3|Pentium|Atom|E3-\d{4}| \d{3} ') {
        Write-Host "ALERT: CPU model type does not meet standards. (i3, Pentium, Xeon E3, etc)"
        $HasError += 1
        $DisplayCPU += 1
    }
}
# AMD CPU
elseif ($CPUManufacturer -like "AuthenticAMD") {
    # Checking for Ryzen
    if ($cpuInfo -match 'Ryzen') {
        # Remove non-numeric characters and convert to int
        $generationMatch = $cpuModel -replace '[^\d]', ''
        $generation = [int]$generationMatch
        
        if ($generation -lt $MinimumAmdGeneration) {
            Write-Host "ALERT: The AMD CPU generation is too old."
            $HasError += 1
            $DisplayCPU += 1
        }
    }
    else {
        Write-Host "ALERT: CPU model type does not meet standards for AMD CPUs."
        $HasError += 1
        $DisplayCPU += 1
    }
}
else {
    Write-Host "ALERT: Not an Intel or AMD CPU"
    $HasError += 1
    $DisplayCPU += 1
}
#Display the CPU model to the console for easy info when there's an error
if ($DisplayCPU -gt 0) {
    Write-Host "CPU Model: $cpuInfo"
}

# Count the number of files in the My Docs folders and alert if they exceed a threshold ($FileLimitInMyDocs)
$UserFolderList = Get-ChildItem c:\users\ | Where-Object { $_.Name -notin @("Public", "adns") }

foreach ($User in $UserFolderList.Name) {
    $MyDocs = "c:\users\$User\Documents"
    $FileCount = (Get-ChildItem -Recurse -File $MyDocs | Measure-Object).Count
    if ($FileCount -gt $FileLimitInMyDocs) {
        Write-Host "`nALERT: $User appears to be saving $FileCount files in their local My Docs folder, and not on the server."
        $HasError += 1
    }
}

# Check if the disk is an SSD
$DiskType = Get-PhysicalDisk | Where-Object { $_.DeviceID -eq "0" } | select -ExpandProperty MediaType
if ($DiskType -notlike "SSD") {
    Write-Host "`nALERT: The primary disk is not an SSD, but is a $DiskType"
    $HasError += 1
}

#Check if joined to a domain
$DomainJoined = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
if (! $DomainJoined) {
    Write-Host "`nALERT: Not joined to a domain."
    $HasError += 1
}

#Check the monitor (display) resolution isn't lower than $MinimumHorizontalResolution or $MinimumVerticalResolution
$monitorInfo = Get-CimInstance Win32_VideoController
$CurrentVerticalResolution = $monitorInfo.CurrentVerticalResolution
$CurrentHorizontalResolution = $monitorInfo.CurrentHorizontalResolution
$VerticalResolution = [int]::MaxValue
$HorizontalResolution = [int]::MaxValue

#If the $monitor.CurrentXResolution is blank, then use the advertised resolution from $monitorInfo.VideoModeDescription. This can happen if the monitor goes to sleep.
if (($null -eq $CurrentVerticalResolution) -or ($null -eq $CurrentHorizontalResolution )) {
    $videoModeDescription = $monitorInfo.VideoModeDescription
    $resolutions = $videoModeDescription | Select-String -Pattern '(\d+) x (\d+)'
    if ($resolutions) {
        $resolutionMatches = $resolutions.Matches[0].Groups
        $CurrentHorizontalResolution = [int]$resolutionMatches[1].Value
        $CurrentVerticalResolution = [int]$resolutionMatches[2].Value
    }
}
else {
    # Otherwise, if there is more than one monitor, then get the lowest resolution of them all.
    foreach ($monitor in $monitorInfo) {
        if ($monitor.CurrentVerticalResolution -lt $verticalResolution) {
            $verticalResolution = $monitor.CurrentVerticalResolution
        }
        if ($monitor.CurrentHorizontalResolution -lt $horizontalResolution) {
            $horizontalResolution = $monitor.CurrentHorizontalResolution
        }
    }
}

#Compare the resolution with $MinimumHorizontalResolution and $MinimumVerticalResolution
if (($horizontalResolution -lt $MinimumHorizontalResolution) -or ($verticalResolution -lt $MinimumVerticalResolution) ) {
    Write-Host "`nALERT: Screen resolution is ($horizontalResolution x $verticalResolution) which is less than ($MinimumHorizontalResolution x $MinimumVerticalResolution)"
    $HasError += 1
}

#Check that the Outlook version installed isn't 2013 or lower.
$OutlookRegistryData = reg query "HKEY_CLASSES_ROOT\Outlook.Application\CurVer" 2>$null # Outlook 2016, 2019, Outlook 365 and above show as version 16 :shrug:

if ($null -ne $OutlookRegistryData) {
    [int]$OutlookVersion = [regex]::Match($OutlookRegistryData, '\.(\d+)').Groups[1].Value
    if ($OutlookVersion -lt $MinimumOutlookVersion ) {
        Write-Host "`nALERT: Outlook version ($OutlookVersion) is less than or equal to version $MinimumOutlookVersion"
        $HasError += 1
    }
}
else {
    #write-host "Outlook not installed.  Moving on..."
}

# Generate alert summary
if ($HasError -gt 0) {
    Write-Host "`n$HasError error(s) were found."
    exit 1
}
else {
    Write-Host "No errors found."
    Exit
}