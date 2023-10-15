#!/bin/bash
# Operating System: macOS

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

# Function to get DNS for an interface
get_dns_for_interface() {
    local interface=$1
    if is_interface_listed "$interface"; then
        echo "DNS for $interface: $(networksetup -getdnsservers "$interface")"
    fi
}

# Check for Wi-Fi and Ethernet DNS configurations
get_dns_for_interface "Wi-Fi"
get_dns_for_interface "Ethernet"

