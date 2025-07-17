#!/bin/bash

echo "=== Zsh Startup Time Analysis ==="
echo

# Quick timing
echo "1. Quick startup time (10 runs):"
for i in {1..10}; do
    /usr/bin/time -f "%e" zsh -i -c exit 2>&1
done | awk '{sum+=$1} END {print "Average: " sum/NR "s"}'
echo

# Profile with zprof
echo "2. Detailed profiling (top functions by time):"
echo "Running: ZSH_PROFILE=1 zsh -i -c exit"
echo "---"
ZSH_PROFILE=1 zsh -i -c exit 2>&1 | tail -n +2

echo
echo "3. Check plugin loading:"
echo "---"
ls -la "$HOME/.cache/antidote/plugins.zsh" 2>/dev/null && echo "Plugin cache exists"

echo
echo "4. Measuring without plugins:"
echo "---"
mv "$HOME/.cache/antidote/plugins.zsh" "$HOME/.cache/antidote/plugins.zsh.bak" 2>/dev/null
echo -n "Without plugins: "
/usr/bin/time -f "%es" zsh -i -c exit 2>&1
mv "$HOME/.cache/antidote/plugins.zsh.bak" "$HOME/.cache/antidote/plugins.zsh" 2>/dev/null

echo
echo "5. Files being sourced:"
echo "---"
DEBUG=0 zsh -i -c exit 2>&1 | grep -E "sourcing|loading" | head -20