# ProtonVPN Port Forwarding with qBittorrent Integration

Automatically maintains ProtonVPN port forwarding using NAT-PMP and updates qBittorrent's listening port configuration.

## Features

- 🔄 Automatic port renewal every 50 seconds (before ProtonVPN's 60-second timeout)
- 🌐 Dynamic VPN gateway detection
- 📁 Automatic qBittorrent configuration updates (port and interface)
- 🔀 Automatic interface switching (proton0 for WireGuard, tun0 for OpenVPN)
- 📊 Comprehensive logging
- 🛡️ Systemd service with security hardening
- 🚦 Graceful handling of servers without port forwarding
- ✅ Port reachability verification using portchecker.io API
- 🔍 Automatic public IP detection and monitoring

## Requirements

- ProtonVPN (port forwarding is only available on certain servers)
- `natpmpc` (NAT-PMP client)
- `curl` (for port reachability checks)
- `nc` (netcat - for creating temporary port listener)
- `ss` (socket statistics - usually included with iproute2)
- `systemd` (for service management)
- `bc` (for network speed calculations in test script)
- `jq` (optional - for formatted JSON output in test script)

## Installation

1. Clone or copy the scripts to your preferred location
2. Make the scripts executable:
   ```bash
   chmod +x protonVPN-port-forward.sh test-network-speed.sh
   ```

3. Install natpmpc if not already installed:
   ```bash
   # Ubuntu/Debian
   sudo apt install natpmpc

   # Fedora
   sudo dnf install libnatpmp

   # Arch
   sudo pacman -S libnatpmp
   ```

4. Copy the systemd service file to your user directory:
   ```bash
   mkdir -p ~/.config/systemd/user/
   cp protonVPN-port-forward.service ~/.config/systemd/user/
   ```

5. Enable and start the service:
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable protonVPN-port-forward.service
   systemctl --user start protonVPN-port-forward.service
   ```

## Usage

### Systemd Service (Recommended)

```bash
# Start the service
systemctl --user start protonVPN-port-forward.service

# Stop the service
systemctl --user stop protonVPN-port-forward.service

# Check service status
systemctl --user status protonVPN-port-forward.service

# View logs
journalctl --user -u protonVPN-port-forward.service -f
```

### Manual Execution

```bash
# Run the script directly
./protonVPN-port-forward.sh

# Run with port reachability checks (for debugging)
./protonVPN-port-forward.sh --check-reachability

# Show help
./protonVPN-port-forward.sh --help
```

### Network Speed Testing

```bash
# Test network performance
./test-network-speed.sh
```

## Configuration

The script automatically:
- Reads the forwarded port from `/run/user/$UID/Proton/VPN/forwarded_port`
- Detects the VPN interface (proton0 for WireGuard, tun0 for OpenVPN)
- Uses ProtonVPN's NAT-PMP gateway (10.2.0.1) for both VPN protocols
- Updates qBittorrent config at `$XDG_CONFIG_HOME/qBittorrent/qBittorrent.conf`
- Logs to `$XDG_CACHE_HOME/Proton/VPN/logs/protonVPN-port-forward.log`

## How It Works

1. **Startup**: Checks for a forwarded port (exits gracefully if server doesn't support port forwarding)
2. **Protocol Detection**: Detects if using WireGuard (proton0) or OpenVPN (tun0)
3. **Gateway Detection**: Uses ProtonVPN's NAT-PMP gateway (10.2.0.1) for both protocols
4. **Public IP Detection**: Gets your public IP address via NAT-PMP
5. **Port Forwarding**: Uses NAT-PMP to establish port mapping
6. **qBittorrent Update**: Updates the listening port and interface in qBittorrent's configuration
7. **Port Verification**: Checks if the port is reachable from the internet
8. **Maintenance Loop**: Renews the port mapping every 50 seconds
9. **Periodic Checks**: Verifies port reachability every 10 minutes
10. **Server Changes**: Gracefully exits if you switch to a server without port forwarding

## Troubleshooting

### Service Won't Start
- Check if the current ProtonVPN server supports port forwarding
- Verify the port file exists: `cat /run/user/$(id -u)/Proton/VPN/forwarded_port`
- Not all ProtonVPN servers support port forwarding - this is normal

### Port Not Updating in qBittorrent
- Ensure qBittorrent is closed when the service updates the config
- Check file permissions on the qBittorrent config file
- Verify the config path is correct

### Port Not Reachable
- Check firewall rules allow incoming connections on the VPN interface:
  - WireGuard: `iifname "proton0" accept`
  - OpenVPN: `iifname "tun0" accept`
- Ensure the firewall rule is placed before any reject rules
- For debugging, run the script manually with reachability checks:
  ```bash
  systemctl --user stop protonVPN-port-forward.service
  ./protonVPN-port-forward.sh --check-reachability
  ```

### View Logs
```bash
# Service logs
journalctl --user -u protonVPN-port-forward.service

# Script logs
tail -f ${XDG_CACHE_HOME:-$HOME/.cache}/Proton/VPN/logs/protonVPN-port-forward.log
```

## Security

The systemd service runs with:
- No new privileges
- Read-only home directory (except for necessary paths)
- Restricted file system access
- User-level permissions only

## Network Speed Test Features

The `test-network-speed.sh` script provides:
- DNS response time testing
- Ping latency measurements
- Download speed test (in KB/s)
- Active TCP connection count
- qBittorrent connection monitoring
- SSL/TLS configuration testing
- Optional cfspeedtest integration

## Notes

- The service will exit gracefully (exit code 0) if you connect to a ProtonVPN server that doesn't support port forwarding
- Port forwarding is only available on certain ProtonVPN servers (typically P2P servers)
- The script automatically handles server changes and port updates

## License

This project is provided as-is for personal use with ProtonVPN services.