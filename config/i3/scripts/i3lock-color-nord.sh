#!/usr/bin/env bash

# -----------------------------
# Nord Theme Lock Screen Script
# -----------------------------

# Nord Theme Colors
NORD_BACKGROUND="2E3440FF"
NORD_RING="D8DEE9FF"
NORD_RING_WRONG="BF616AFF"
NORD_RING_VERIFY="A3BE8CFF"
NORD_LINE="D8DEE9FF"
NORD_TEXT="D8DEE9FF"

# i3lock configuration
i3lock --color=$NORD_BACKGROUND --inside-color=$NORD_BACKGROUND --ring-color=$NORD_RING --insidewrong-color=$NORD_BACKGROUND --ringwrong-color=$NORD_RING_WRONG --insidever-color=$NORD_BACKGROUND --ringver-color=$NORD_RING_VERIFY --line-color=$NORD_LINE --keyhl-color=$NORD_RING_VERIFY --bshl-color=$NORD_RING_WRONG --time-color=$NORD_TEXT --date-color=$NORD_TEXT --layout-color=$NORD_TEXT --time-str="%H:%M:%S" --date-str="%A, %d %B %Y" --radius=120 --ring-width=10 --clock