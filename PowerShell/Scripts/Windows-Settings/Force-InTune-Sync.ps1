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
# Name: Syncronize device to Intune
# Description: Force the device to sync up with Intune Management Extension (IME)
#
# Timeout: 300
# Version: 1.0
#
# -----------------------------------------------------------------------------

$Shell = New-Object -ComObject Shell.Application
$Shell.open("intunemanagementextension://syncapp")