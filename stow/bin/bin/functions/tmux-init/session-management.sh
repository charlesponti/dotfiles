#!/usr/bin/env bash
# Tmux session management functions

# Check if tmux is installed
check_tmux_installed() {
    if ! command -v tmux &>/dev/null; then
        log_error "tmux is not installed"
        log_error "Install with: brew install tmux"
        return 1
    fi
}

# Ensure work directory exists
ensure_work_dir() {
    if [[ ! -d "$WORK_DIR" ]]; then
        log_info "Creating work directory: $WORK_DIR"
        mkdir -p "$WORK_DIR"
    fi
}

# Check if a tmux session exists
session_exists() {
    tmux "${TMUX_SOCKET_ARGS[@]}" has-session -t "$SESSION_NAME" 2>/dev/null
}

# Create a new tmux session
create_session() {
    log_info "Creating new tmux session: $SESSION_NAME in $WORK_DIR"
    tmux "${TMUX_SOCKET_ARGS[@]}" new-session -d -s "$SESSION_NAME" -c "$WORK_DIR"
    log_info "Session '$SESSION_NAME' created"
}

# Attach to an existing tmux session
attach_session() {
    log_info "Attaching to existing session: $SESSION_NAME"
    
    # Check if we're already inside tmux
    if [[ -n "${TMUX:-}" ]]; then
        # Switch to session instead of attach
        tmux "${TMUX_SOCKET_ARGS[@]}" switch-client -t "$SESSION_NAME"
    else
        # Attach to session
        tmux "${TMUX_SOCKET_ARGS[@]}" attach-session -t "$SESSION_NAME"
    fi
}

# Main tmux initialization logic
main() {
    # Verify tmux is installed
    check_tmux_installed || exit 1
    
    # Ensure work directory exists
    ensure_work_dir
    
    # Check if session exists
    if session_exists; then
        # Attach to existing session
        attach_session
    else
        # Create new session
        create_session
        
        # If not attached, attach now
        if [[ -z "${TMUX:-}" ]]; then
            attach_session
        fi
    fi
}

# Display usage information
usage() {
    cat << EOF
Usage: $(basename "$0") [SESSION_NAME] [WORK_DIR]

Auto-launch tmux with intelligent session management.

Arguments:
    SESSION_NAME    Name of tmux session (default: main)
    WORK_DIR        Working directory (default: ~/Developer or ~)

Examples:
    # Create/attach to default 'main' session
    $(basename "$0")
    
    # Create/attach to custom session
    $(basename "$0") myproject
    
    # Create session in specific directory
    $(basename "$0") myproject /path/to/project
    
    # Use with Ghostty (add to ~/.config/ghostty/config):
    # command = $HOME/.dotfiles/bin/tmux-init.sh

EOF
}
