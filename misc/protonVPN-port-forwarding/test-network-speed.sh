#!/bin/bash
# Test network speed to diagnose slowdowns

echo "Testing network speed..."
echo "========================"

# Test DNS
echo -n "DNS response time: "
time dig @1.1.1.1 google.com +short > /dev/null 2>&1

# Test latency
echo -e "\nPing test (5 packets):"
ping -c 5 1.1.1.1

# Test download speed
echo -e "\nDownload speed test:"
echo "Downloading 10MB test file (max 30 seconds)..."
output=$(curl -o /dev/null -w "%{time_total} %{speed_download}" \
  --max-time 30 --connect-timeout 5 \
  https://speed.cloudflare.com/__down?bytes=10000000 2>/dev/null)

if [ $? -eq 0 ]; then
    time_total=$(echo $output | cut -d' ' -f1)
    speed_bytes=$(echo $output | cut -d' ' -f2)
    speed_kb=$(echo "scale=2; $speed_bytes / 1024" | bc 2>/dev/null || echo "N/A")
    echo "Downloaded 10MB in ${time_total}s at ${speed_kb} KB/s"
else
    echo "Download test failed (timeout or connection error)"
    # Try alternative test with smaller file
    echo "Trying alternative speed test with 1MB file..."
    output=$(curl -o /dev/null -w "%{time_total} %{speed_download}" \
      --max-time 10 --connect-timeout 5 \
      https://www.kernel.org/pub/linux/kernel/v6.x/ChangeLog-6.0.1 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        time_total=$(echo $output | cut -d' ' -f1)
        speed_bytes=$(echo $output | cut -d' ' -f2)
        speed_kb=$(echo "scale=2; $speed_bytes / 1024" | bc 2>/dev/null || echo "N/A")
        echo "Downloaded small file in ${time_total}s at ${speed_kb} KB/s"
    else
        echo "All download tests failed - check internet connection"
    fi
fi

# Check active connections
echo -e "\nActive connections:"
ss -s | grep TCP

# Check if qBittorrent is hogging connections
if pgrep qbittorrent > /dev/null; then
    echo -e "\nqBittorrent connections:"
    ss -tnp 2>/dev/null | grep -i qbittorrent | wc -l
fi

# Test SSL/TLS configuration
echo -e "\n========================"
echo "SSL/TLS Configuration Test:"
echo "========================"
if command -v jq &> /dev/null; then
    curl -s https://www.howsmyssl.com/a/check | jq '{
        tls_version: .tls_version,
        rating: .rating,
        cipher_suites: (.cipher_suites | length),
        beast_vuln: .beast_vuln,
        insecure_cipher_suites: .insecure_cipher_suites
    }'
else
    echo "Note: Install 'jq' for formatted SSL test output"
    curl -s https://www.howsmyssl.com/a/check | grep -E "(tls_version|rating)" | head -2
fi

# Run cfspeedtest if available
if command -v cfspeedtest &> /dev/null; then
    echo -e "\n========================"
    echo "Running Cloudflare Speed Test..."
    echo "========================"
    cfspeedtest
else
    echo -e "\nNote: Install 'cfspeedtest' for more detailed speed tests"
    echo "  Using cargo: cargo install cfspeedtest"
    echo "  Or download from: https://github.com/code-inflation/cfspeedtest"
fi