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
# Name: Windows DNS Server Check
# Description: This script retrieves the DNS servers used on the device, compares
# them to the expected configuration, and alerts if they don't match.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows DNS Server Check
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - expected_dns_servers

# Array of expected DNS servers
$expectedDnsServers = @("1.1.1.1", "1.0.0.1")

# -----------------------------------------------------------------------------

# Function to check if the DNS servers match the expected configuration
function Check-DnsServers {
    param (
        [string[]]$ExpectedDnsServers
    )

    $networkInterfaces = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }

    foreach ($interface in $networkInterfaces) {
        $dnsServers = $interface.DNSServerSearchOrder

        Write-Host "Interface: $($interface.Description)"
        Write-Host "Expected DNS servers: $($ExpectedDnsServers -join ', ')"
        Write-Host "Current DNS servers: $($dnsServers -join ', ')"

        if ($dnsServers -ne $null -and $dnsServers.Length -gt 0) {
            $matchingServers = Compare-Object $dnsServers $ExpectedDnsServers

            Write-Host "Matching DNS servers: $($matchingServers -join ', ')"
            Write-Host "Comparison Result: $($matchingServers -eq $null)"
            Write-Host "Comparison Details:"
            $matchingServers | ForEach-Object {
                Write-Host "  - $_"
            }

            if ($matchingServers -eq $null) {
                Write-Host "ALERT: DNS servers do not match the expected configuration"
                Write-Host "Comparison Result: $($matchingServers -eq $null)"
                Write-Host "Actual DNS servers: $($dnsServers -join ', ')"
                Write-Host "Expected DNS servers: $($ExpectedDnsServers -join ', ')"
                exit 1
            }
        }
        else {
            Write-Host "ALERT: No DNS servers configured"
            exit 1
        }
    }
}

# Check if the DNS servers match the expected configuration
Check-DnsServers -ExpectedDnsServers $expectedDnsServers
