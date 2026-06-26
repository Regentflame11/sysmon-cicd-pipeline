#!/bin/bash

# Clear terminal screen
clear

# Define Colors for beautiful CLI output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===============================================${NC}"
echo -e "${YELLOW}           SYSTEM HEALTH DASHBOARD             ${NC}"
echo -e "${BLUE}===============================================${NC}"
echo -e "Current Time: $(date)"
echo -e "Hostname:     $(hostname 2>/dev/null || cat /etc/hostname 2>/dev/null || echo $HOSTNAME)"
echo -e "Uptime:       $(uptime -p 2>/dev/null || uptime)"
echo -e "${BLUE}-----------------------------------------------${NC}"

# CPU Usage calculation
cpu_idle=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
if [ -n "$cpu_idle" ]; then
    cpu_load=$(awk -v idle="$cpu_idle" 'BEGIN {print 100 - idle}')
    echo -e "CPU Usage:    ${GREEN}${cpu_load}%${NC}"
else
    echo -e "CPU Usage:    ${RED}N/A (Check top/procps installation)${NC}"
fi

# Memory Usage calculation
if command -v free &> /dev/null; then
    mem_total=$(free -m | awk '/^Mem:/{print $2}')
    mem_used=$(free -m | awk '/^Mem:/{print $3}')
    mem_pct=$(free | awk '/^Mem:/{printf "%.2f", $3/$2*100}')
    echo -e "Memory:       ${GREEN}${mem_used}MB / ${mem_total}MB (${mem_pct}%)${NC}"
else
    echo -e "Memory:       ${RED}N/A (Check free/procps installation)${NC}"
fi

# Disk Usage calculation
disk_total=$(df -h / | awk 'NR==2 {print $2}')
disk_used=$(df -h / | awk 'NR==2 {print $3}')
disk_pct=$(df -h / | awk 'NR==2 {print $5}')
echo -e "Disk Space:   ${GREEN}${disk_used} / ${disk_total} (${disk_pct})${NC}"

echo -e "${BLUE}===============================================${NC}"
