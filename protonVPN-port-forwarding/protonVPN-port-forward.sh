#!/bin/bash

# ProtonVPN port forwarding keeper

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PORT_FILE="/run/user/$(id -u)/Proton/VPN/forwarded_port"
RENEW_INTERVAL=50 # Renew 10 seconds before expiry
LOG_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/Proton/VPN/logs"
LOG_FILE="$LOG_DIR/protonVPN-port-forward.log"
QBITTORRENT_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/qBittorrent/qBittorrent.conf"

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -h, --help             Show this help message"
            exit 0
            ;;
    esac
done

# log messages to STDOUT and log file
log() {
    local message="$1"
    # Strip ANSI color codes for log file
    local clean_message=$(echo "$message" | sed 's/\x1b\[[0-9;]*m//g')
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $clean_message" >> "$LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message"
}

get_gateway() {
    # ProtonVPN uses the same NAT-PMP gateway for both WireGuard and OpenVPN
    # Check if connected via either interface
    if ip link show proton0 &>/dev/null || ip link show tun0 &>/dev/null; then
        echo "10.2.0.1"  # ProtonVPN NAT-PMP gateway for both protocols
        return
    fi
    
    log "${RED}Error: ProtonVPN not connected (no proton0 or tun0 interface found)${NC}"
    exit 1
}

get_public_ip() {
    local gateway=$1
    local public_ip
    public_ip=$(natpmpc -g "$gateway" 2>/dev/null | awk '/Public IP address/ {print $5}')
    # Only return the IP, no logging inside the function
    echo "$public_ip"
}

get_port() {
    if [ -f "$PORT_FILE" ]; then
        cat "$PORT_FILE" 2>/dev/null
    else
        echo ""
    fi
}

renew_port() {
    local port=$1
    local gateway=$2
    natpmpc -a "$port" "$port" tcp 60 -g "$gateway" >/dev/null 2>&1
    return $?
}

update_qbittorrent_config() {
    local port=$1
    local interface=$2
    
    if [ -f "$QBITTORRENT_CONFIG" ]; then
        # Create a backup
        cp "$QBITTORRENT_CONFIG" "${QBITTORRENT_CONFIG}.bak"

        # Update port and interface using sed (matching literal backslash in config)
        if sed -i \
            -e 's/Connection\\PortRangeMin=.*/Connection\\PortRangeMin='"$port"'/' \
            -e 's/Session\\Port=.*/Session\\Port='"$port"'/' \
            -e 's/Session\\Interface=.*/Session\\Interface='"$interface"'/' \
            -e 's/Session\\InterfaceName=.*/Session\\InterfaceName='"$interface"'/' \
            "$QBITTORRENT_CONFIG"; then
            log "Updated qBittorrent: port=$port, interface=$interface"
            return 0
        else
            log "Failed to update qBittorrent configuration"
            # Restore backup on failure
            mv "${QBITTORRENT_CONFIG}.bak" "$QBITTORRENT_CONFIG"
            return 1
        fi
    else
        log "${RED}qBittorrent config file not found at $QBITTORRENT_CONFIG${NC}"
        return 1
    fi
}

cleanup() {
    log "Port forwarding keeper stopped"
    exit 0
}
trap cleanup SIGINT SIGTERM

# Main script
echo -e "${GREEN}ProtonVPN Port Forwarding Keeper${NC}"
echo "=================================="

# Check if running as regular user
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: Do not run this script as root${NC}"
    exit 1
fi

# Check if natpmpc is installed
if ! command -v natpmpc &>/dev/null; then
    echo -e "${RED}Error: natpmpc is not installed${NC}"
    echo "Please install it using one of the following commands:"
    echo "  Ubuntu/Debian: sudo apt install natpmpc"
    echo "  Fedora: sudo dnf install libnatpmp"
    echo "  Arch: sudo pacman -S libnatpmp"
    exit 1
fi

# Ensure log directory exists
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
fi

# Check if port forwarding is available
PORT=$(get_port)
if [ -z "$PORT" ]; then
    echo -e "${YELLOW}No forwarded port found. This ProtonVPN server may not support port forwarding.${NC}"
    echo "This is normal for servers without port forwarding support."
    exit 0
fi

# Get VPN gateway and detect protocol
GATEWAY=$(get_gateway)
if [ -z "$GATEWAY" ]; then
    echo -e "${RED}Error: Could not determine VPN gateway${NC}"
    exit 1
fi

# Detect VPN protocol and interface
VPN_PROTOCOL=""
VPN_INTERFACE=""
if ip link show proton0 &>/dev/null; then
    VPN_PROTOCOL="WireGuard"
    VPN_INTERFACE="proton0"
elif ip link show tun0 &>/dev/null; then
    VPN_PROTOCOL="OpenVPN"
    VPN_INTERFACE="tun0"
fi

echo -e "${GREEN}Port to forward: ${NC}$PORT"
echo -e "${GREEN}VPN Protocol: ${NC}$VPN_PROTOCOL"
echo -e "${GREEN}Gateway: ${NC}$GATEWAY"
echo -e "${GREEN}Log file: ${NC}$LOG_FILE"
echo ""

log "[!] Starting port forwarding keeper for port $PORT"

# Get public IP
PUBLIC_IP=$(get_public_ip "$GATEWAY")
if [ -n "$PUBLIC_IP" ]; then
    echo -e "${GREEN}Public IP: ${NC}$PUBLIC_IP"
    log "${GREEN}Public IP: $PUBLIC_IP${NC}"
else
    echo -e "${YELLOW}Warning: Could not determine public IP${NC}"
    log "Warning: Could not determine public IP"
fi

# Update qBittorrent configuration on startup
update_qbittorrent_config "$PORT" "$VPN_INTERFACE"

# Main loop
consecutive_failures=0

while true; do
    # Check if port has changed or disappeared
    current_port=$(get_port)
    if [ "$current_port" != "$PORT" ]; then
        log "Port changed from $PORT to $current_port"
        PORT=$current_port
        if [ -z "$PORT" ]; then
            log "Port forwarding no longer available (server may have changed)"
            echo -e "${YELLOW}Port forwarding is no longer available. The VPN server may have changed.${NC}"
            echo "Exiting gracefully."
            exit 0
        fi
        # Update qBittorrent with new port
        update_qbittorrent_config "$PORT" "$VPN_INTERFACE"
    fi

    # Renew port forwarding
    if renew_port "$PORT" "$GATEWAY"; then
        echo -e "${GREEN}[$(date '+%H:%M:%S')] Port $PORT forwarding renewed${NC}"
        consecutive_failures=0
    else
        consecutive_failures=$((consecutive_failures + 1))
        echo -e "${YELLOW}[$(date '+%H:%M:%S')] Failed to renew port forwarding (attempt $consecutive_failures)${NC}"

        # Exit after 3 consecutive failures
        if [ $consecutive_failures -ge 3 ]; then
            log "Too many consecutive failures, stopping"
            echo -e "${RED}Failed to renew port forwarding 3 times, exiting${NC}"
            break
        fi
    fi

    # Sleep before next renewal
    sleep $RENEW_INTERVAL
done

cleanup
