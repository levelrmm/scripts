#!/bin/bash
#
# Operating System: macOS
#
# Monitor DNS configurations to see if they've changed.

DNS_PRIMARY="1.1.1.1"
DNS_SECONDARY="192.168.0.144"

# Function to check if an interface is listed in network services
is_interface_listed() {
    local interface=$1
    # Check if the interface is listed in the output of networksetup command
    if networksetup -listallnetworkservices | grep -q "^$interface$"; then
        return 0 # Listed
    else
        return 1 # Not listed
    fi
}

# Function to check DNS for an interface
check_dns_for_interface() {
    local interface=$1
    if is_interface_listed "$interface"; then
        local dns_values
        dns_values=$(networksetup -getdnsservers "$interface")
        if echo "$dns_values" | grep -q "$DNS_PRIMARY"; then
            echo "$interface DNS is configured to $DNS_PRIMARY" 
        else
            echo "$interface DNS is NOT configured to $DNS_PRIMARY" 
        fi

        if [[ -n "$DNS_SECONDARY" ]]; then
            if echo "$dns_values" | grep -q "$DNS_SECONDARY"; then
            	echo "$interface DNS is configured to $DNS_PRIMARY" 
            else
            	echo "$interface DNS is NOT configured to $DNS_PRIMARY" 
            fi
        fi
    fi
}

# Check for Wi-Fi and Ethernet DNS configurations
check_dns_for_interface "Wi-Fi"
check_dns_for_interface "Ethernet"

