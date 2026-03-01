# simple system information helper

sysinfo() {
  echo "$(uname -s) $(uname -r) $(uname -m)"
  echo "Uptime: $(uptime | awk '{print $3,$4}' | sed 's/,//')"
  if command -v sysctl >/dev/null 2>&1; then
    sysctl -n machdep.cpu.brand_string
  fi
}
