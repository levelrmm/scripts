# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Monitor - Open Ports
# Description: This script lists inbound open/listening ports on a device and checks for 
# unauthorized ports. Requires PowerShell 3.0 or later.
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Open Ports
# Script output: Contains
# Output value: ERROR
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - authorized_ports

# Authorized inbound ports
$authorized_ports = @(135, 139, 3389, 5040)  # Add or remove ports as needed
# -----------------------------------------------------------------------------

# Get the list of inbound open/listening ports
$open_ports = Get-NetTCPConnection -State Listen | Where-Object { $_.OwningProcess -ne $null }

# Variables to track the number of unauthorized ports found
$unauthorized_count = 0
$unauthorized_ports = @()

# Iterate over the open ports
foreach ($port in $open_ports) {
    if ($authorized_ports -notcontains $port.LocalPort) {
        $processName = (Get-Process -Id $port.OwningProcess).Name
        $portInfo = "Port: $($port.LocalPort), Process: $processName"
        Write-Host "ALERT: Unauthorized inbound port is in use - $portInfo"
        $unauthorized_count++
        $unauthorized_ports += $portInfo
    }
}

# Check if any unauthorized ports were found
if ($unauthorized_count -gt 0) {
    Write-Host "ERROR: $unauthorized_count unauthorized inbound ports found"
    Write-Host "Unauthorized inbound ports in use:"
    $unauthorized_ports | ForEach-Object { Write-Host $_ }
}
else {
    Write-Host "SUCCESS"
}
