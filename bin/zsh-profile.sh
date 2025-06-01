#!/usr/bin/env bash
# ZSH profiling script to identify slow components

echo "🔍 Profiling ZSH startup components..."
echo "This will show which parts of your .zshrc are taking the most time"
echo ""

# Enable zsh profiling
export PROFILE_STARTUP=true

# Run zsh with profiling
time zsh -c '
# Add profiling to zshrc temporarily
echo "zmodload zsh/zprof" > /tmp/profile_zshrc
cat ~/.zshrc >> /tmp/profile_zshrc
echo "zprof" >> /tmp/profile_zshrc

# Source the profiled version
source /tmp/profile_zshrc

# Clean up
rm /tmp/profile_zshrc
'
