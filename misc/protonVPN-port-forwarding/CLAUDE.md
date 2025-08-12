# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose
This repository implements ProtonVPN port forwarding maintenance scripts that:
- Read the forwarded port from ProtonVPN's runtime file
- Use NAT-PMP protocol to maintain port forwarding
- Refresh the mapping every 50 seconds (before ProtonVPN's 60-second timeout)

## Main Components
- `protonVPN-port-forward.sh`: Main script with logging, error handling, VPN checks, and qBittorrent integration
- `protonVPN-port-forward.service`: Systemd service file for automatic startup and management

## Common Commands
```bash
# Install the service (run once)
systemctl --user enable protonVPN-port-forward.service

# Start the service
systemctl --user start protonVPN-port-forward.service

# Stop the service
systemctl --user stop protonVPN-port-forward.service

# Check service status
systemctl --user status protonVPN-port-forward.service

# View logs
journalctl --user -u protonVPN-port-forward.service -f

# Test network speed
./test-network-speed.sh
```

## Architecture Overview
1. **Port Discovery**: Scripts read from `/run/user/$UID/Proton/VPN/forwarded_port`
2. **Gateway Detection**: Dynamically detects VPN gateway IP from proton0 interface
3. **NAT-PMP Protocol**: Uses `natpmpc` to establish port mappings
4. **Renewal Cycle**: Refreshes every 50 seconds using sleep loops
5. **Port Reachability Check**: Verifies port is accessible from the internet using portchecker.io API
6. **Process Management**: Uses systemd for daemon control
7. **Service Integration**: Includes systemd service files for automatic startup
8. **qBittorrent Integration**: Automatically updates qBittorrent's configuration when ProtonVPN assigns a new port:
   - Updates Connection\\PortRangeMin and Session\\Port (port numbers)
   - Updates Session\\Interface and Session\\InterfaceName (proton0 for WireGuard, tun0 for OpenVPN)

## Key Implementation Details
- Scripts check for non-root execution
- VPN connection validation before attempting port forwarding
- Signal handling (SIGINT/SIGTERM) for graceful shutdown
- Logging to `$XDG_CACHE_HOME/Proton/VPN/logs/protonVPN-port-forward.log`
- Error recovery with configurable retry attempts
- Port reachability verification on startup and every 10 minutes
- Automatic public IP detection and change handling

## Development Guidelines
When modifying scripts:
1. Preserve error handling and logging patterns
2. Test with actual ProtonVPN connection before committing
3. Update README if functionality changes
4. Ensure qBittorrent integration works correctly
5. Use environment variables instead of hardcoded paths