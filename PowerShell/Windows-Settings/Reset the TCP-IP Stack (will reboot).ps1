<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Reset the TCP/IP stack.  This will reboot the device!
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

netsh winsock reset
netsh int ip reset
Restart-Computer -force