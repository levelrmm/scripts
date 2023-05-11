<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Join computer to Active Directory domain and reboot
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Prepare Script
$ErrorActionPreference = "Continue"
$Output = @()

#$Records=Import-CSV C:\Scripts\Oui.csv

# Ping Search
$IPs = 1..254 | ForEach -Process { WmiObject -Class Win32_PingStatus -Filter ("Address='10.0.0." + $_ + "'") }
$DevicesOnly = $IPs | Where-Object { $_.StatusCode -eq 0 }


#Extract Data
ForEach ($Device in $DevicesOnly) {
    $Address = $Device.ProtocolAddress
    $MAC = arp -a $Address | Select-String '([0-9a-f]{2}-){5}[0-9a-f]{2}' | Select-Object -Expand Matches | Select-Object -Expand Value
    # https://stackoverflow.com/questions/41632656/getting-the-mac-address-by-arp-a
    $DNSName = Resolve-DNSName -Name $Address -Server 8.8.8.8 | Select-Object NameHost
    $HostName = $DNSName.NameHost
    $PCMAC = $MAC.SubString(0, 8) + ' '
    <#
            ForEach ($Record in $Records){ 
                        If ($Record.MAC -eq $PCMAC){
                        $Vendor=$Record.Vendor        
            } 
    }         
#>

    #Write Data to Object
    $Systems = New-Object -TypeName PSObject
    $Systems | Add-Member -Type NoteProperty -Name IP -Value $Address
    $Systems | Add-Member -Type NoteProperty -Name MAC -Value $Mac
    $Systems | Add-Member -Type NoteProperty -Name Hostname -Value $HostName
    #$Systems | Add-Member -Type NoteProperty -Name Vendor -Value $Vendor
    $Output += $Systems
}

#Write Output
$Output | Select-Object Hostname, IP, MAC | Format-Table