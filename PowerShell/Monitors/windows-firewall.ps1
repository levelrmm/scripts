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
# Name: Windows Monitor - Windows Firewall
# Description: This script lists the status of the Windows firewall.  Create
# a Level monitor that will alert if "False" is contained in the output.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Registry Setting
# Script output: Contains
# Output value: False
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# -----------------------------------------------------------------------------

# Get the status of the Windows firewall (all three profiles)
get-netfirewallprofile | select Name, Enabled