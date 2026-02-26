#!/usr/bin/env bash
# =============================================================================
# Tmux-sessions: Pre-configured workspace templates
# 
# Purpose: Quickly create standardized development workspaces
# Usage:
#   tmux-sessions.sh              # Show help
#   tmux-sessions.sh dev          # Create web dev workspace
#   tmux-sessions.sh custom name  # Create custom workspace
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

# Default session name
SESSION_NAME="${1:-dev}"
SESSION_TYPE="${2:-}"

# Working directory (current directory or provided)
WORK_DIR="${3:-$(pwd)}"

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

log_info() {
    echo "[INFO] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

# Check if tmux is installed
check_tmux() {
    if ! command -v tmux &>/dev/null; then
        log_error "tmux is not installed"
        exit 1
    fi
}

# Kill session if it exists
kill_session_if_exists() {
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        log_info "Killing existing session: $SESSION_NAME"
        tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true
    fi
}

# Create web development workspace
create_dev_workspace() {
    log_info "Creating web development workspace: $SESSION_NAME"
    
    # Create session with initial window
    tmux new-session -d -s "$SESSION_NAME" -c "$WORK_DIR"
    
    # Window 1: editor (already created as window 0, rename it)
    tmux rename-window -t 0 'editor'
    
    # Split editor window: 67% editor, 33% command line
    tmux split-window -h -t "$SESSION_NAME:0" -c "$WORK_DIR"
    tmux select-layout -t "$SESSION_NAME:0" 'main-horizontal'
    tmux resize-pane -t "$SESSION_NAME:0.0" -x 67 -y 0
    
    # Window 2: server (dev server)
    tmux new-window -t "$SESSION_NAME" -c "$WORK_DIR" -n 'server'
    tmux send-keys -t "$SESSION_NAME:1" 'echo "Start your dev server here (npm start, yarn dev, etc.)"' Enter
    
    # Window 3: logs
    tmux new-window -t "$SESSION_NAME" -c "$WORK_DIR" -n 'logs'
    tmux send-keys -t "$SESSION_NAME:2" 'echo "Tail logs here (tail -f, kubectl logs, etc.)"' Enter
    
    # Select first window
    tmux select-window -t "$SESSION_NAME:0"
    
    log_info "Web dev workspace created with 3 windows:"
    log_info "  - Window 1: editor (split: editor + command)"
    log_info "  - Window 2: server (run dev server)"
    log_info "  - Window 3: logs (tail logs)"
    log_info ""
    log_info "Attach with: tmux attach-session -t $SESSION_NAME"
}

# Create minimal session (just a shell)
create_minimal_workspace() {
    log_info "Creating minimal workspace: $SESSION_NAME"
    
    tmux new-session -d -s "$SESSION_NAME" -c "$WORK_DIR"
    tmux rename-window -t 0 'main'
    
    log_info "Minimal workspace created"
    log_info "Attach with: tmux attach-session -t $SESSION_NAME"
}

# Create monitoring workspace
create_monitoring_workspace() {
    log_info "Creating monitoring workspace: $SESSION_NAME"
    
    # Create session with first window
    tmux new-session -d -s "$SESSION_NAME" -c "$WORK_DIR"
    
    # Window 1: logs
    tmux rename-window -t 0 'logs'
    
    # Window 2: metrics
    tmux new-window -t "$SESSION_NAME" -c "$WORK_DIR" -n 'metrics'
    tmux send-keys -t "$SESSION_NAME:1" 'htop' Enter
    
    # Window 3: shell
    tmux new-window -t "$SESSION_NAME" -c "$WORK_DIR" -n 'shell'
    
    tmux select-window -t "$SESSION_NAME:0"
    
    log_info "Monitoring workspace created"
}

# Create general purpose workspace
create_general_workspace() {
    log_info "Creating general workspace: $SESSION_NAME"
    
    tmux new-session -d -s "$SESSION_NAME" -c "$WORK_DIR"
    tmux rename-window -t 0 'shell1'
    
    tmux new-window -t "$SESSION_NAME" -c "$WORK_DIR" -n 'shell2'
    tmux new-window -t "$SESSION_NAME" -c "$WORK_DIR" -n 'shell3'
    
    tmux select-window -t "$SESSION_NAME:0"
    
    log_info "General workspace created with 3 shell windows"
}

# Attach to existing session
attach_to_session() {
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        log_info "Attaching to existing session: $SESSION_NAME"
        tmux attach-session -t "$SESSION_NAME"
    else
        log_error "Session '$SESSION_NAME' does not exist"
        log_error "Create it first with: tmux-sessions.sh $SESSION_NAME"
        exit 1
    fi
}

# Show help
show_help() {
    cat << EOF
Tmux-sessions: Pre-configured workspace templates

Usage: 
    $(basename "$0") [SESSION_NAME] [TEMPLATE] [WORK_DIR]
    $(basename "$0") attach [SESSION_NAME]

Templates:
    dev         Web development (editor + server + logs)
    minimal     Just a shell (single window)
    monitoring  Logs + metrics + shell
    general     Three shell windows

Examples:
    # Create web dev workspace named 'myproject'
    $(basename "$0") myproject dev
    
    # Create in specific directory
    $(basename "$0") myproject dev ~/Projects/myapp
    
    # Attach to existing session
    $(basename "$0") attach myproject
    
    # Quick minimal session
    $(basename "$0") work minimal ~/Work

Session Types:
    dev         - Editor + server + logs (recommended for web dev)
    minimal     - Single shell window
    monitoring  - Logs + htop + shell
    general     - 3 shell windows for general work

If no template specified, defaults to 'dev' workspace.
If session already exists, use 'attach' to connect to it.

EOF
}

# List sessions
list_sessions() {
    echo "Active tmux sessions:"
    tmux list-sessions -F "  - #{session_name} (#{session_windows} windows, #{session_attached} attached)"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    check_tmux
    
    # Handle special commands
    case "$SESSION_NAME" in
        -h|--help|help)
            show_help
            exit 0
            ;;
        list|ls)
            list_sessions
            exit 0
            ;;
        attach)
            SESSION_NAME="${2:-main}"
            attach_to_session
            exit 0
            ;;
    esac
    
    # Determine template
    TEMPLATE="${SESSION_TYPE:-dev}"
    
    # Ensure work directory exists
    if [[ ! -d "$WORK_DIR" ]]; then
        log_info "Creating work directory: $WORK_DIR"
        mkdir -p "$WORK_DIR"
    fi
    
    # Create workspace based on template
    case "$TEMPLATE" in
        dev|development|web)
            kill_session_if_exists
            create_dev_workspace
            ;;
        minimal|shell|single)
            kill_session_if_exists
            create_minimal_workspace
            ;;
        monitor|monitoring|ops)
            kill_session_if_exists
            create_monitoring_workspace
            ;;
        general|multi)
            kill_session_if_exists
            create_general_workspace
            ;;
        *)
            log_error "Unknown template: $TEMPLATE"
            log_error "Use: dev, minimal, monitoring, or general"
            exit 1
            ;;
    esac
    
    # Attach to session
    tmux attach-session -t "$SESSION_NAME"
}

# Run main
main
