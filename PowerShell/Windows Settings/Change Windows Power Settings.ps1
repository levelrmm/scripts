<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Set Power settings
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Settings when plugged in to external power
Powercfg /Change standby-timeout-ac 0   #Sleep timer
Powercfg /Change hibernate-timeout-ac 0 #Hibernate timer "0" means never
Powercfg /Change monitor-timeout-ac 20  #Monitor sleep timer

#Settings when running on battery power
Powercfg /Change standby-timeout-dc 60  #Sleep timer
Powercfg /Change hibernate-timeout-dc 0 #Hibernate timer "0" means never
Powercfg /Change monitor-timeout-dc 10  #Monitor sleep timer
