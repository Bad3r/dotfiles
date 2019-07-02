#!/bin/bash


# find system FQDN
FQDN=$(hostname -a | cut -d ' ' -f1)
ip=$(hostname -I | cut -d ' ' -f1)
clear
echo "*****************************************************************"
echo "System report for: $FQDN ($ip)"
echo "Genrated at $(date)"
echo "*****************************************************************"

echo "Up time:           $(uptime -p | cut -d ',' -f1)"
echo "Number of users:   $(uptime | cut -d ',' -f2)"
echo "Kernel version:    $(uname -r)"
echo "Load average:      $(uptime | cut -d ',' -f3 | cut -d ':' -f2)"
echo "$(cat /proc/meminfo | grep MemFree)"

usedMem=$(free -t -m | grep Mem | cut -d ' ' -f20)
freeMem=$(free -t -m | grep Mem | cut -d ' ' -f29)
echo "Memory status:      $usedMem M used ($freeMem M free)"
echo "*****************************************************************"



