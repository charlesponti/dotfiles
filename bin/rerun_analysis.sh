#!/bin/bash

# ==============================================================================
# Network & System Analysis Script
# ==============================================================================
# This script replicates the manual analysis steps taken to diagnose internet
# slowdowns and high system load. It checks network latency, bandwidth,
# active connections, system load, disk I/O, and specific background processes.
# ==============================================================================

# --- Configuration & Colors ---

# ANSI Color Codes
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Helper Functions ---

log() {
    local level=$1
    local message=$2
    local timestamp
    timestamp=$(date "+%H:%M:%S")
    case $level in
        "INFO")
            echo -e "${BLUE}[${timestamp}] ${BOLD}INFO:${NC} ${message}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[${timestamp}] ${BOLD}SUCCESS:${NC} ${message}"
            ;;
        "WARN")
            echo -e "${YELLOW}[${timestamp}] ${BOLD}WARN:${NC} ${message}"
            ;;
        "ERROR")
            echo -e "${RED}[${timestamp}] ${BOLD}ERROR:${NC} ${message}"
            ;;
        "HEADER")
            echo -e "
${CYAN}${BOLD}=== ${message} ===${NC}
"
            ;;
    esac
}

run_cmd() {
    local cmd_str="$1"
    local desc="$2"
    
    log "INFO" "Executing: ${desc}"
    echo -e "${YELLOW}> ${cmd_str}${NC}"
    
    # Run the command and capture exit code
    eval "$cmd_str"
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        log "SUCCESS" "Command completed successfully."
    else
        log "ERROR" "Command failed with exit code ${exit_code}."
        # We don't exit the script here to allow diagnostics to continue
    fi
    echo "" # Spacer
}

check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        log "WARN" "Command '$1' not found. Skipping related checks."
        return 1
    fi
    return 0
}

# --- Main Execution ---

clear
echo -e "${BOLD}Starting Network & System Diagnostic Tool${NC}"
echo "---------------------------------------------"

# 1. Network Latency & Packet Loss
log "HEADER" "Checking Network Latency & Packet Loss"
run_cmd "ping -c 5 8.8.8.8" "Pinging Google DNS (8.8.8.8) to check for latency and packet loss..."

# 2. Network Bandwidth / Quality
log "HEADER" "Checking Network Quality (macOS native)"
if check_dependency "networkquality"; then
    run_cmd "networkquality" "Running macOS networkquality tool for upload/download/responsiveness..."
else
    log "INFO" "Skipping networkquality check (not available on this OS version)."
fi

# 3. Active Network Connections
log "HEADER" "Analyzing Active Network Connections"
run_cmd "lsof -Pni | grep ESTABLISHED | head -n 20" "Listing top 20 active established connections (DNS resolution disabled for speed)..."

# 4. System Load & CPU Usage
log "HEADER" "Checking System Load & CPU Usage"
run_cmd "top -l 1 -n 10 -o cpu" "Capturing snapshot of top 10 processes sorted by CPU usage..."

# 5. Disk I/O Activity
log "HEADER" "Checking Disk I/O Activity"
run_cmd "iostat -d -w 1 -c 5" "Monitoring disk I/O for 5 seconds to detect heavy write operations..."

# 6. Specific Background Processes
log "HEADER" "Investigating Known Resource Hogs"
log "INFO" "Checking for specific processes: storedownloadd, nsurlsessiond, backupd, mdworker (Spotlight), OrbStack"
run_cmd "ps -e -o pid,pcpu,comm | grep -E 'storedownloadd|nsurlsessiond|backupd|mdworker|OrbStack' | grep -v grep | head -n 20" "Listing suspect background processes..."

# 7. Time Machine Status
log "HEADER" "Checking Time Machine Status"
if check_dependency "tmutil"; then
    run_cmd "tmutil status" "Checking if a Time Machine backup is currently running..."
fi

log "HEADER" "Analysis Complete"
log "SUCCESS" "Diagnostic run finished. Please review the output above."
