#!/usr/bin/env bash

set -euo pipefail

swap_line=$(sysctl vm.swapusage 2>/dev/null || true)
therm=$(pmset -g therm 2>/dev/null || true)
mem_pressure=$(memory_pressure -Q 2>/dev/null || true)

echo "resource-scan:"
echo " - swap: ${swap_line}"
echo " - therm: ${therm}"
echo " - memory-pressure: ${mem_pressure}"
