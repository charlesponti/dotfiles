#!/usr/bin/env bash
# ZSH startup time benchmark

echo "🚀 Benchmarking ZSH startup time..."
echo "Running 10 iterations to get average..."

total=0
for i in {1..10}; do
    start=$(gdate +%s%N 2>/dev/null || date +%s%N)
    zsh -c "exit" 2>/dev/null
    end=$(gdate +%s%N 2>/dev/null || date +%s%N)
    
    duration=$(( ($end - $start) / 1000000 ))
    echo "Run $i: ${duration}ms"
    total=$(( $total + $duration ))
done

average=$(( $total / 10 ))
echo ""
echo "📊 Average startup time: ${average}ms"

if [ $average -lt 200 ]; then
    echo "🔥 Excellent! Your shell is blazing fast!"
elif [ $average -lt 500 ]; then
    echo "⚡ Good! Your shell starts up quickly."
elif [ $average -lt 1000 ]; then
    echo "⚠️  Moderate. Could be faster."
else
    echo "🐌 Slow. Needs more optimization."
fi
