#!/usr/bin/env bash
set -euo pipefail

runs=20
budget_ms=150
label="zsh startup"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --runs)
      runs="${2:?missing run count}"
      shift 2
      ;;
    --budget-ms)
      budget_ms="${2:?missing budget}"
      shift 2
      ;;
    --label)
      label="${2:?missing label}"
      shift 2
      ;;
    -h|--help)
      cat <<'EOF'
Usage: bench-shell.sh [--runs N] [--budget-ms MS] [--label TEXT]
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

python3 - "$runs" "$budget_ms" "$label" <<'PY'
import statistics
import subprocess
import sys
import time

runs = max(1, int(sys.argv[1]))
budget_ms = float(sys.argv[2])
label = sys.argv[3]

samples = []
for _ in range(runs):
    start = time.perf_counter()
    subprocess.run(
        ["zsh", "-i", "-c", "exit"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    samples.append((time.perf_counter() - start) * 1000)

samples.sort()
p95_index = min(len(samples) - 1, max(0, int(round(0.95 * (len(samples) - 1)))))
p95 = samples[p95_index]
avg = statistics.mean(samples)
print(f"{label}: runs={runs} avg={avg:.1f}ms p95={p95:.1f}ms min={samples[0]:.1f}ms max={samples[-1]:.1f}ms")

if budget_ms > 0 and p95 > budget_ms:
    print(f"budget exceeded: {p95:.1f}ms > {budget_ms:.1f}ms", file=sys.stderr)
    sys.exit(1)
PY