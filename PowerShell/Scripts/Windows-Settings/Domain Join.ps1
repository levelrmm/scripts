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

#Setup variables for domain, username, and password.  Ensure that the the device is using the DCs for DNS.
$domain = "INSERT_DOMAIN_HERE.COM"
$username = "$domain\INSERT_USERNAME_HERE" 
$password = "INSERT_PASSWORD_HERE" | ConvertTo-SecureString -asPlainText -Force

#Run the domain join command
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential -restart