#!/usr/bin/env bash

# macOS System Configuration Runner
# This script provides an interactive way to apply macOS system configurations

set -e

MACOS_DIR="$HOME/.dotfiles/bin/macos"
source "$HOME/.dotfiles/bin/printf.sh"

# Helper function for errors
error() {
    fail "$1"
}

# Available configuration modules
MODULES="finder:Finder preferences and behavior
dock:Dock appearance and behavior
trackpad:Trackpad and input settings
spotlight:Spotlight search configuration
base:Core system preferences (UI, performance, etc.)"

show_help() {
    echo "Usage: $0 [options] [modules...]"
    echo ""
    echo "Apply macOS system configurations selectively or all at once."
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -a, --all      Apply all configurations"
    echo "  -l, --list     List available modules"
    echo "  -i, --interactive  Interactive mode"
    echo ""
    echo "Available modules:"
    echo "$MODULES" | while IFS=: read -r module desc; do
        printf "  %-12s %s\n" "$module" "$desc"
    done
    echo ""
    echo "Examples:"
    echo "  $0 --all                    # Apply all configurations"
    echo "  $0 finder dock             # Apply only Finder and Dock settings"
    echo "  $0 --interactive           # Choose modules interactively"
}

list_modules() {
    echo "Available configuration modules:"
    echo "$MODULES" | while IFS=: read -r module desc; do
        printf "  %-12s %s\n" "$module" "$desc"
    done
}

apply_module() {
    local module="$1"
    local script_path="$MACOS_DIR/${module}.sh"
    
    if [[ ! -f "$script_path" ]]; then
        error "Module '$module' not found at $script_path"
        return 1
    fi
    
    informer "Applying $module configuration..."
    if bash "$script_path"; then
        success "$module configuration applied"
    else
        error "Failed to apply $module configuration"
        return 1
    fi
}

interactive_mode() {
    echo "=== macOS Configuration - Interactive Mode ==="
    echo ""
    
    local selected_modules=()
    
    echo "$MODULES" | while IFS=: read -r module desc; do
        echo -n "Apply $module ($desc)? [y/N]: "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            selected_modules+=("$module")
        fi
    done
    
    if [[ ${#selected_modules[@]} -eq 0 ]]; then
        echo "No modules selected. Exiting."
        return 0
    fi
    
    echo ""
    echo "Selected modules: ${selected_modules[*]}"
    echo -n "Proceed with applying these configurations? [y/N]: "
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        for module in "${selected_modules[@]}"; do
            apply_module "$module"
        done
        run_cleanup
    else
        echo "Configuration cancelled."
    fi
}

run_cleanup() {
    informer "Running cleanup tasks..."
    
    # Kill affected applications to apply changes
    if [[ -f "$MACOS_DIR/killall.sh" ]]; then
        bash "$MACOS_DIR/killall.sh"
    fi
    
    success "Configuration complete! Some changes may require a restart to take effect."
}

main() {
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        error "This script is designed for macOS only."
        exit 1
    fi
    
    # Check if dotfiles directory exists
    if [[ ! -d "$MACOS_DIR" ]]; then
        error "macOS configuration directory not found at $MACOS_DIR"
        exit 1
    fi
    
    # Parse arguments
    local apply_all=false
    local interactive=false
    local modules_to_apply=()
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -a|--all)
                apply_all=true
                shift
                ;;
            -l|--list)
                list_modules
                exit 0
                ;;
            -i|--interactive)
                interactive=true
                shift
                ;;
            -*)
                error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                # Check if module exists
                if echo "$MODULES" | grep -q "^$1:"; then
                    modules_to_apply+=("$1")
                else
                    error "Unknown module: $1"
                    list_modules
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Execute based on mode
    if [[ "$interactive" == true ]]; then
        interactive_mode
    elif [[ "$apply_all" == true ]]; then
        echo "Applying all macOS configurations..."
        echo "$MODULES" | while IFS=: read -r module desc; do
            apply_module "$module"
        done
        run_cleanup
    elif [[ ${#modules_to_apply[@]} -gt 0 ]]; then
        for module in "${modules_to_apply[@]}"; do
            apply_module "$module"
        done
        run_cleanup
    else
        echo "No action specified. Use --help for usage information."
        show_help
        exit 1
    fi
}

main "$@"
