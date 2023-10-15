#!/bin/bash
# Operating System: macOS

# Set the primary and secondary DNS
PRIMARY_DNS="192.168.0.144"
SECONDARY_DNS=""

# Network service names for Ethernet and Wi-Fi
NETWORK_SERVICES=("Ethernet" "Wi-Fi")

# Check if the script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Iterate over each network service and update the DNS
for service in "${NETWORK_SERVICES[@]}"; do
	networksetup -listallnetworkservices | grep -q "$service"; then
    	if [ $? -eq 0 ]; then
		# Check for empty SECONDARY_DNS string
		if [ -z $SECONDARY_DNS ]; then
			networksetup -setdnsservers "$service" "$PRIMARY_DNS" 
		else
			networksetup -setdnsservers "$service" "$PRIMARY_DNS" "$SECONDARY_DNS"
		fi
		echo "DNS servers for $service have been set to $PRIMARY_DNS and $SECONDARY_DNS"
	fi
done

