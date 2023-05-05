<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Change the UUID of Level and restart the Level service.  This is useful
    if devices are fighting over the same agent record in Level due to 
    having the same UUID.  This can sometime occur with disk cloning.  After
    this is run, the device that receives this command will check-in to
    Level and create a new agent record.

.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Get current UUID
$CurrentUUID = & 'C:\Program Files\Level\Level.exe' /get-uuid
#Display the current UUID
$CurrentUUID

#Create a new UUID with PowerShell's "new-guid"
$UUID = new-guid
& 'C:\Program Files\Level\Level.exe' /set-uuid "$UUID"

#Restart the Level service
restart-service level