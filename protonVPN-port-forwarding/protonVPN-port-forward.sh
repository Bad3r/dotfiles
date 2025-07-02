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
CHECK_REACHABILITY=false
for arg in "$@"; do
    case $arg in
        --check-reachability)
            CHECK_REACHABILITY=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --check-reachability    Enable port reachability testing"
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

check_port_reachable() {
    local ip=$1
    local port=$2
    local nc_pid=""
    local cleanup_needed=false

    # Check if something is already listening on the port
    if ! ss -lnt | grep -q ":$port "; then
        # Nothing is listening, start a temporary netcat listener
        timeout 10 nc -l -p "$port" >/dev/null 2>&1 &
        nc_pid=$!
        cleanup_needed=true
        # Give netcat a moment to start listening
        sleep 1
    fi

    # Use portchecker.io API
    local response
    response=$(curl -s -w "\n%{http_code}" https://portchecker.io/api/query \
        --request POST \
        --header 'Content-Type: application/json' \
        --data "{\"host\": \"$ip\", \"ports\": [$port]}" \
        --max-time 8 2>/dev/null)

    # Clean up netcat if its running
    if [ "$cleanup_needed" = true ] && [ -n "$nc_pid" ]; then
        kill $nc_pid 2>/dev/null || true
    fi

    local http_code
    http_code=$(echo "$response" | tail -n1)
    local body
    body=$(echo "$response" | head -n-1)

    if [ "$http_code" = "200" ]; then
        # Check if port is reachable
        local status
        status=$(echo "$body" | grep -o '"status":[^,}]*' | head -1 | cut -d':' -f2 | tr -d ' ')
        if [ "$status" = "true" ]; then
            return 0
        else
            return 1
        fi
    else
        log "${RED}Port check API error: HTTP $http_code${NC}"
        return 2
    fi
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

# Initial port reachability check
if [ "$CHECK_REACHABILITY" = true ] && [ -n "$PUBLIC_IP" ]; then
    echo "Checking port reachability..."
    if check_port_reachable "$PUBLIC_IP" "$PORT"; then
        echo -e "${GREEN}✓ Port $PORT is reachable from the internet${NC}"
        log "Port $PORT is reachable from public IP $PUBLIC_IP"
    else
        echo -e "${YELLOW}⚠ Port $PORT is not reachable from the internet${NC}"
        log "[!] Warning: Port $PORT is not reachable from public IP $PUBLIC_IP"
        echo "This might be normal during initial setup. Will check again later."
    fi
fi

# Main loop
consecutive_failures=0
check_counter=0
CHECK_INTERVAL=12 # Check port every 12 cycles (10 minutes)

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
        # Reset check counter to check reachability soon after port change
        check_counter=$((CHECK_INTERVAL - 2))
    fi

    # Renew port forwarding
    if renew_port "$PORT" "$GATEWAY"; then
        echo -e "${GREEN}[$(date '+%H:%M:%S')] Port $PORT forwarding renewed${NC}"
        consecutive_failures=0

        # Periodic port reachability check
        if [ "$CHECK_REACHABILITY" = true ]; then
            check_counter=$((check_counter + 1))
            if [ $check_counter -ge $CHECK_INTERVAL ] && [ -n "$PUBLIC_IP" ]; then
                check_counter=0
                if check_port_reachable "$PUBLIC_IP" "$PORT"; then
                    log "Periodic check: Port $PORT is still reachable"
                else
                    echo -e "${YELLOW}⚠ Port $PORT is no longer reachable from the internet${NC}"
                    log "Warning: Port $PORT is no longer reachable from public IP $PUBLIC_IP"
                    # Try to get new public IP in case it changed
                    NEW_PUBLIC_IP=$(get_public_ip "$GATEWAY")
                    if [ -n "$NEW_PUBLIC_IP" ] && [ "$NEW_PUBLIC_IP" != "$PUBLIC_IP" ]; then
                        PUBLIC_IP=$NEW_PUBLIC_IP
                        echo -e "${YELLOW}Public IP changed to: $PUBLIC_IP${NC}"
                        log "${YELLOW}Public IP changed to: $PUBLIC_IP${NC}"
                    fi
                fi
            fi
        fi
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
