#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/lib.sh"
source "$SCRIPT_DIR/status-health.sh"

CYAN='\033[0;36m'
WHITE='\033[1;37m'
GEAR="⚙️"
FOLDER="📁"

# Main routing
case "${1:-summary}" in
    health)
        show_health
        ;;
    help)
        show_help
        ;;
    dashboard)
        show_dashboard
        ;;
    summary|"")
        show_summary
        ;;
    *)
        echo "Usage: $0 [health|help|dashboard|summary]"
        echo
        echo "  health    - Run comprehensive health check"
        echo "  help      - Show command reference"
        echo "  dashboard - Show status dashboard"
        echo "  summary   - Show quick summary (default)"
        exit 1
        ;;
esac
