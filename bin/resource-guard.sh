#!/usr/bin/env bash

set -euo pipefail

max_swap_gb="${1:-2.0}"
swap_line=$(sysctl vm.swapusage 2>/dev/null || true)
therm=$(pmset -g therm 2>/dev/null | tr '[:upper:]' '[:lower:]' || true)

used_mb=$(python3 - "$swap_line" <<'PY'
import re
import sys
line = sys.argv[1]
m = re.search(r"used\s*=\s*([0-9.]+)M", line)
print(m.group(1) if m else "0")
PY
)

used_gb=$(python3 - "$used_mb" <<'PY'
import sys
print(f"{float(sys.argv[1]) / 1024.0:.4f}")
PY
)

throttled="false"
if [[ "$therm" == *"cpu_speed_limit"* ]]; then
  throttled="true"
fi

echo "resource-guard swap-gb=${used_gb} max=${max_swap_gb} throttled=${throttled}"

python3 - "$used_gb" "$max_swap_gb" "$throttled" <<'PY'
import sys
used = float(sys.argv[1])
limit = float(sys.argv[2])
throttled = sys.argv[3] == "true"
if used > limit or throttled:
    sys.exit(1)
PY
