<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
   Check to see if Windows is activated.  If not, assign a key and activate
   Windows.

.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Set your product key here
$Key = "INSERT-WINDOWS-PRODUCT-KEY-HERE"

#Check current activation status.  If already activated, do not change the key.
$ActivationStatus = Get-CimInstance SoftwareLicensingProduct -Filter "partialproductkey is not null" | ? name -like windows* | where { $_.PartialProductKey } | select -ExpandProperty LicenseStatus
if ($ActivationStatus) {
    Write-Host "Windows is already activated.  Exiting without changing the key."
    exit
}

#Change the key
slmgr.vbs -ipk $Key