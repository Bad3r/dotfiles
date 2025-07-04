#!/usr/bin/env python3.13
import os
import sys
import json
import time
import signal
import logging
import argparse
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
from pathlib import Path

import httpx

# Configure logger
logger = logging.getLogger(__name__)

# ANSI color codes
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    MAGENTA = '\033[0;35m'
    CYAN = '\033[0;36m'
    WHITE = '\033[0;37m'
    RESET = '\033[0m'

class ColoredFormatter(logging.Formatter):
    """Custom formatter that adds colors and icons to log output"""
    
    COLORS = {
        logging.DEBUG: Colors.BLUE,
        logging.INFO: Colors.GREEN,
        logging.WARNING: Colors.YELLOW,
        logging.ERROR: Colors.RED,
        logging.CRITICAL: Colors.MAGENTA,
    }
    
    ICONS = {
        logging.DEBUG: "🐛",    # Debug icon
        logging.INFO: "ℹ",      # Info icon
        logging.WARNING: "⚠",   # Warning icon
        logging.ERROR: "✖",     # Error icon
        logging.CRITICAL: "🚨", # Critical icon
    }
    
    def format(self, record):
        # Get the icon and color for this level
        icon = self.ICONS.get(record.levelno, "•")
        color = self.COLORS.get(record.levelno, "")
        
        # Create custom format with icon
        record.levelname = f"{color}({icon}){Colors.RESET}"
        
        # Format the message
        formatted = super().format(record)
        
        return formatted

class PortCheckHandler(BaseHTTPRequestHandler):
    """Simple HTTP handler to log incoming connections"""
    def do_GET(self):
        logger.info(f"Received connection from {Colors.CYAN}{self.client_address[0]}{Colors.RESET}")
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Port check successful")
    
    def log_message(self, format, *args):
        """Override to use our logger"""
        logger.debug(f"{self.client_address[0]} - {format % args}")

def setup_logging(logfile=None, quiet=False, json_output=False):
    """Configure logging based on arguments"""
    # Suppress httpx and httpcore logging
    logging.getLogger("httpx").setLevel(logging.WARNING)
    logging.getLogger("httpcore").setLevel(logging.WARNING)
    
    if quiet or json_output:
        logging.basicConfig(level=logging.CRITICAL)
    elif logfile:
        # File logging - with timestamps but no colors/icons
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            filename=logfile
        )
    else:
        # Console logging - with colors and icons, no timestamp
        handler = logging.StreamHandler(sys.stdout)
        handler.setFormatter(ColoredFormatter('%(levelname)s %(message)s'))
        logging.basicConfig(
            level=logging.INFO,
            handlers=[handler]
        )

def get_public_ip() -> str:
    """Get public IP from ifconfig.me"""
    logger.debug("Fetching public IP from ifconfig.me")
    headers = {"User-Agent": "curl/7.68.0"}  # ifconfig.me returns plain text for curl
    response = httpx.get("https://ifconfig.me", headers=headers, timeout=10)
    response.raise_for_status()
    ip = response.text.strip()
    logger.info(f"Public IP: {Colors.CYAN}{ip}{Colors.RESET}")
    return ip

def get_proton_port() -> int:
    """Get port from ProtonVPN runtime file"""
    port_file = Path(f"/run/user/{os.getuid()}/Proton/VPN/forwarded_port")
    if port_file.exists():
        port = int(port_file.read_text().strip())
        logger.info(f"ProtonVPN forwarded port: {Colors.YELLOW}{port}{Colors.RESET}")
        return port
    raise FileNotFoundError("ProtonVPN port file not found")

def try_start_server(port: int) -> tuple[HTTPServer | None, bool]:
    """
    Try to start HTTP server on port.
    Returns (server, port_was_free)
    """
    try:
        server = HTTPServer(('', port), PortCheckHandler)
        server.timeout = 10
        thread = threading.Thread(target=server.serve_forever)
        thread.daemon = True
        thread.start()
        logger.info(f"Started temporary server on port {Colors.YELLOW}{port}{Colors.RESET}")
        return server, True
    except OSError as e:
        if e.errno == 98:  # Address already in use
            logger.warning(f"Port {Colors.YELLOW}{port}{Colors.RESET} is already in use")
            return None, False
        raise

def check_port_via_api(ip: str, port: int) -> tuple[bool, str]:
    """Check port using portchecker.io API"""
    logger.debug(f"Checking port {port} on {ip} via portchecker.io")
    try:
        response = httpx.post(
            "https://portchecker.io/api/query",
            json={"host": ip, "ports": [port]},
            timeout=8
        )
        response.raise_for_status()
        
        data = response.json()
        if data and isinstance(data, dict) and "check" in data:
            checks = data.get("check", [])
            if checks and len(checks) > 0:
                is_open = checks[0].get("status", False)
                return is_open, "Port is open" if is_open else "Port is closed"
        return False, "Invalid API response format"
    except httpx.TimeoutException:
        return False, "API request timed out"
    except Exception as e:
        return False, f"API error: {str(e)}"

def handle_signal(signum, frame):
    """Clean exit on signal"""
    logger.info("Received interrupt signal")
    sys.exit(130)

def main():
    parser = argparse.ArgumentParser(
        description="Check if a port is reachable from the internet",
        epilog="Exit codes: 0=reachable, 1=not reachable, 2=API error, 3=config error"
    )
    parser.add_argument("port", type=int, nargs="?", help="Port to check (default: from ProtonVPN)")
    parser.add_argument("ip", nargs="?", help="Public IP address (default: auto-detect)")
    parser.add_argument("-j", "--json", action="store_true", help="Output in JSON format")
    parser.add_argument("-q", "--quiet", action="store_true", help="Suppress log output")
    parser.add_argument("--logfile", help="Log to file instead of stdout")
    
    args = parser.parse_args()
    
    # Setup logging
    setup_logging(args.logfile, args.quiet, args.json)
    
    # Setup signal handlers
    signal.signal(signal.SIGINT, handle_signal)
    signal.signal(signal.SIGTERM, handle_signal)
    
    result = {
        "ip": None,
        "port": None,
        "reachable": False,
        "message": None,
        "error": None
    }
    
    server = None
    exit_code = 0
    
    try:
        # Get IP and port with defaults
        try:
            result["ip"] = args.ip or get_public_ip()
            result["port"] = args.port or get_proton_port()
        except FileNotFoundError as e:
            result["error"] = "ProtonVPN port file not found"
            result["message"] = str(e)
            exit_code = 3
            raise
        except Exception as e:
            result["error"] = "Failed to get IP or port"
            result["message"] = str(e)
            exit_code = 3
            raise
        
        # Try to start server on port
        server, started_server = try_start_server(result["port"])
        
        # Give server time to start if we created one
        if started_server:
            time.sleep(1)
        
        # Check via API
        reachable, message = check_port_via_api(result["ip"], result["port"])
        result["reachable"] = reachable
        result["message"] = message
        
        if not reachable and "API error" in message:
            exit_code = 2
        elif not reachable:
            exit_code = 1
            
    except Exception as e:
        if not result["error"]:  # Don't overwrite specific errors
            result["error"] = str(e)
            exit_code = 3
    finally:
        # Clean up server if we started one
        if server:
            server.shutdown()
            logger.debug("Temporary server stopped")
    
    # Output results
    if args.json:
        # Clean output for JSON mode
        output = {k: v for k, v in result.items() if v is not None}
        print(json.dumps(output))
    else:
        # Human-readable output
        if result["error"]:
            logger.error(f"Error: {result['error']}")
        elif result["reachable"]:
            logger.info(f"Port {Colors.YELLOW}{result['port']}{Colors.RESET} is reachable from {Colors.CYAN}{result['ip']}{Colors.RESET} 🎉")
        else:
            logger.warning(f"{Colors.RED}✗{Colors.RESET} Port {Colors.YELLOW}{result['port']}{Colors.RESET} is NOT reachable from {Colors.CYAN}{result['ip']}{Colors.RESET}: {result['message']}")
    
    sys.exit(exit_code)

if __name__ == "__main__":
    main()