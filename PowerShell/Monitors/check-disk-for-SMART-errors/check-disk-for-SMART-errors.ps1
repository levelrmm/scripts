# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Monitor - Check Disk for SMART errors
# Description: Download smartctl and check all disks for S.M.A.R.T. errors
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Disk has SMART errors
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 24
# -----------------------------------------------------------------------------

$smartctlPath = "c:\temp\smartctl.exe"
$HasError = 0  # Initialize error counter

# Download smartctl if not present
if (-not (Test-Path -path $smartctlPath)) {
    Write-Host "Downloading smartctl`n"
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Try {
        iwr -uri https://github.com/levelsoftware/scripts/raw/main/PowerShell/Monitors/check-disk-for-SMART-errors/smartctl.exe -outfile (New-Item -Path $smartctlPath -Force) -ErrorAction Stop
        $FileSize = [math]::round((Get-Item -Path $smartctlPath).Length / 1MB, 2)
        Write-Host "Downloaded $smartctlPath - $FileSize MB"
    }
    Catch {
        Write-Host "Failed to download smartctl. Error: $_" -ForegroundColor Red
        Exit 1
    }
}
else {
    Write-Host "Smartctl already present at $smartctlPath`n"
}

# Scanning for all disks
$disks = & $smartctlPath --scan | ForEach-Object {
    if ($_ -match '/dev/(\S+)') {
        $matches[1]
    }
}

# Function to check for predictive failure
function CheckForFailure {
    param ($output)
    if ($output -match "SMART overall-health self-assessment test result: FAILED!") {
        return $true
    }
    return $false
}

# Function to check for errors in smartctl output
function CheckForErrors {
    param ($output)
    if ($output -match "SMART command failed") {
        return $true
    }
    return $false
}

# Checking each disk for SMART data and generating alerts
foreach ($disk in $disks) {
    Write-Host "Checking SMART data for disk: $disk"
    $smartOutput = & $smartctlPath --health /dev/$disk
    if (CheckForErrors -output $smartOutput) {
        Write-Host "Error encountered while checking disk $disk. Skipping..." -ForegroundColor Yellow
        continue
    }
    if (CheckForFailure -output $smartOutput) {
        Write-Host "ALERT: Predictive failure detected on disk $disk" -ForegroundColor Red
        $HasError += 1
    }
    $smartOutput
}

# Generate alert summary
if ($HasError -gt 0) {
    Write-Host "`n$HasError disk(s) found to have error(s)." -ForegroundColor Red
    exit 1
}
else {
    Write-Host "No errors found."
    Exit
}
