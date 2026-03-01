#!/usr/bin/env bash
# Consolidated status and help system for dotfiles
# Usage: ./status.sh [health|help|dashboard|summary]

set -euo pipefail

# Get the directory where this script is located  
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load library
source "$SCRIPT_DIR/lib.sh"

# Source status functions
source "$SCRIPT_DIR/functions/status/health-check.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Unicode symbols
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
