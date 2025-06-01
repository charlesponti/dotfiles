#!/usr/bin/env bash
# Terminal Performance Monitoring Tool

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}🚀 Terminal Performance Monitor${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
}

benchmark_startup() {
    echo -e "${YELLOW}📊 Running startup benchmark...${NC}"
    
    # Run the existing benchmark
    if [ -f "$HOME/.dotfiles/bin/zsh-benchmark.sh" ]; then
        bash "$HOME/.dotfiles/bin/zsh-benchmark.sh"
    else
        echo "Benchmark script not found"
    fi
    echo
}

check_plugin_load_times() {
    echo -e "${YELLOW}🔍 Analyzing plugin load times...${NC}"
    
    # Create a temporary zsh config that loads plugins with timing
    temp_zsh="/tmp/zsh_profile_test.zsh"
    cat > "$temp_zsh" << 'EOF'
# Enable zsh profiling
zmodload zsh/zprof

# Source the main zshrc
source ~/.zshrc

# Print profiling results
zprof
EOF
    
    echo "Running plugin analysis..."
    zsh -c "source $temp_zsh" 2>/dev/null | head -20
    rm -f "$temp_zsh"
    echo
}

check_path_duplicates() {
    echo -e "${YELLOW}🛤️  Checking for PATH duplicates...${NC}"
    
    # Split PATH and find duplicates
    echo "$PATH" | tr ':' '\n' | sort | uniq -d | while read -r dup; do
        if [ -n "$dup" ]; then
            echo -e "${RED}Duplicate PATH entry: $dup${NC}"
            count=$(echo "$PATH" | tr ':' '\n' | grep -c "^$dup$")
            echo -e "${RED}  Appears $count times${NC}"
        fi
    done
    
    # Count total PATH entries
    total_entries=$(echo "$PATH" | tr ':' '\n' | wc -l)
    unique_entries=$(echo "$PATH" | tr ':' '\n' | sort -u | wc -l)
    duplicates=$((total_entries - unique_entries))
    
    if [ $duplicates -eq 0 ]; then
        echo -e "${GREEN}✅ No PATH duplicates found${NC}"
    else
        echo -e "${YELLOW}⚠️  Found $duplicates duplicate PATH entries${NC}"
    fi
    echo "Total PATH entries: $total_entries"
    echo "Unique PATH entries: $unique_entries"
    echo
}

check_shell_functions() {
    echo -e "${YELLOW}⚙️  Shell function analysis...${NC}"
    
    # Count functions
    func_count=$(declare -F | wc -l)
    echo "Total shell functions loaded: $func_count"
    
    # List custom functions from dotfiles
    echo "Custom functions from your dotfiles:"
    declare -F | awk '{print $3}' | grep -E '^(git|npm|docker|qr|backup|find)' | sort | head -10
    echo
}

check_aliases() {
    echo -e "${YELLOW}🔗 Alias analysis...${NC}"
    
    alias_count=$(alias | wc -l)
    echo "Total aliases loaded: $alias_count"
    
    echo "Most useful aliases:"
    echo "Git aliases: $(alias | grep -c '^alias g')"
    echo "Docker aliases: $(alias | grep -c '^alias d')"
    echo "Node/NPM aliases: $(alias | grep -c '^alias n')"
    echo
}

provide_recommendations() {
    echo -e "${YELLOW}💡 Performance Recommendations:${NC}"
    echo
    
    # Check for common performance issues
    recommendations=()
    
    # Check if NVM is lazy loaded
    if grep -q "nvm()" ~/.zshrc; then
        recommendations+=("✅ NVM is lazy loaded - good!")
    else
        recommendations+=("⚠️  Consider lazy loading NVM for faster startup")
    fi
    
    # Check if using turbo mode
    if grep -q "zinit wait" ~/.zshrc; then
        recommendations+=("✅ Using Zinit turbo mode - excellent!")
    else
        recommendations+=("⚠️  Consider using Zinit turbo mode for plugins")
    fi
    
    # Check for instant prompt
    if grep -q "POWERLEVEL9K_INSTANT_PROMPT" ~/.zshrc; then
        recommendations+=("✅ Powerlevel10k instant prompt enabled - great!")
    else
        recommendations+=("💡 Enable Powerlevel10k instant prompt for faster startup")
    fi
    
    # Print recommendations
    for rec in "${recommendations[@]}"; do
        echo -e "$rec"
    done
    echo
    
    echo -e "${GREEN}🎯 Additional Tips:${NC}"
    echo "• Use 'time zsh -c exit' to measure startup time"
    echo "• Run 'zinit times' to see plugin load times"
    echo "• Consider removing unused plugins"
    echo "• Use lazy loading for heavy tools (nvm, rvm, etc.)"
    echo "• Keep your dotfiles in version control"
}

show_system_info() {
    echo -e "${YELLOW}💻 System Information:${NC}"
    echo "Shell: $SHELL"
    echo "ZSH Version: $(zsh --version | cut -d' ' -f2)"
    echo "Terminal: $TERM_PROGRAM"
    echo "OS: $(uname -s) $(uname -r)"
    echo
}

main() {
    print_header
    show_system_info
    benchmark_startup
    check_path_duplicates
    check_shell_functions
    check_aliases
    provide_recommendations
    
    echo -e "${GREEN}🎉 Performance analysis complete!${NC}"
    echo -e "${BLUE}Run this tool periodically to monitor your terminal performance.${NC}"
}

# Run main function
main "$@"
