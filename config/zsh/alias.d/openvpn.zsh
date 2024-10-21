# route ssh traffic via tun0
sshtun0() {
    # Check if tun0 interface exists
    if ip link show tun0 &>/dev/null; then
        # Extract the IP address associated with tun0
        local tun0_ip=$(ip -4 addr show tun0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

        # Check if the IP address was found
        if [ -n "$tun0_ip" ]; then
            # Run the SSH command with the tun0 IP address
            ssh -b "$tun0_ip" "$@"
        else
            echo "Could not retrieve the IP address for tun0."
        fi
    else
        echo "tun0 interface does not exist."
    fi
}
