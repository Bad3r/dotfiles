#---------------------------------------------------------------------------
# *                            Nmap Aliases
#---------------------------------------------------------------------------

# Nmap options are:
#  -sS - TCP SYN scan
#  -v - verbose
#  -T1 - timing of scan. Options are paranoid (0), sneaky (1), polite (2), normal (3), aggressive (4), and insane (5)
#  -sF - FIN scan (can sneak through non-stateful firewalls)
#  -PE - ICMP echo discovery probe
#  -PP - timestamp discovery probe
#  -PY - SCTP init ping
#  -g - use given number as source port
#  -A - enable OS detection, version detection, script scanning, and traceroute (aggressive)
#  -O - enable OS detection
#  -sA - TCP ACK scan
#  -F - fast scan
#  --script=vuln - also access vulnerabilities in target



# `nmap_open_ports`: scan for open ports on target.
alias nmap_open_ports="nmap --open"

# `nmap_list_interfaces`: list all network interfaces on host where the command runs.
alias nmap_list_interfaces="nmap --iflist"

# `nmap_slow`: slow scan that avoids to spam the targets logs.
alias nmap_slow="sudo nmap -sS -v -T1"

# `nmap_fin`: scan to see if hosts are up with TCP FIN scan.
alias nmap_fin="sudo nmap -sF -v"

# `nmap_full`: aggressive full scan that scans all ports, tries to determine OS and service versions.
alias nmap_full="sudo nmap -sS -T4 -PE -PP -PS80,443 -PY -g 53 -A -p1-65535 -v"

# `nmap_check_for_firewall`: TCP ACK scan to check for firewall existence.
alias nmap_check_for_firewall="sudo nmap -sA -p1-65535 -v -T4"

# `nmap_ping_through_firewall`: host discovery with SYN and ACK probes instead of just pings to avoid firewall restrictions.
alias nmap_ping_through_firewall="nmap -PS -PA"

# `nmap_fast`: fast scan of the top 300 popular ports.
alias nmap_fast="nmap -F -T5 --version-light --top-ports 300"

# `nmap_detect_versions`: detects versions of services and OS, runs on all ports.
alias nmap_detect_versions="sudo nmap -sV -p1-65535 -O --osscan-guess -T4 -Pn"

# `nmap_check_for_vulns`: uses vulscan script to check target services for vulnerabilities.
alias nmap_check_for_vulns="nmap --script=vuln"

# `nmap_full_udp`: same as full but via UDP.
alias nmap_full_udp="sudo nmap -sS -sU -T4 -A -v -PE -PS22,25,80 -PA21,23,80,443,3389 "

# `nmap_traceroute`: try to traceroute using the most common ports.
alias nmap_traceroute="sudo nmap -sP -PE -PS22,25,80 -PA21,23,80,3389 -PU -PO --traceroute "

# `nmap_full_with_scripts`: same as nmap_full but also runs all the scripts.
alias nmap_full_with_scripts="sudo nmap -sS -sU -T4 -A -v -PE -PP -PS21,22,23,25,80,113,31339 -PA80,113,443,10042 -PO --script all " 

# `nmap_web_safe_osscan`: little "safer" scan for OS version  as connecting to only HTTP and HTTPS ports doesn't look so attacking.
alias nmap_web_safe_osscan="sudo nmap -p 80,443 -O -v --osscan-guess --fuzzy "

# `nmap_ping_scan`: ICMP scan for active hosts.
alias nmap_ping_scan="nmap -n -sP"

