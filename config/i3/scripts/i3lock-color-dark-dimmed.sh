#!/usr/bin/env bash

# ------------------------------------
# Dark Dimmed Theme Lock Screen Script
# ------------------------------------

# Dark Dimmed Theme Colors (from dark.dimmed.json5)
DD_BACKGROUND="262c36FF"      # Using $dd_grey_vdark from config
DD_RING="768390FF"             # Using $dd_grey
DD_RING_WRONG="f47067FF"       # Using $dd_red
DD_RING_VERIFY="57ab5aFF"      # Using $dd_green
DD_LINE="545d68FF"             # Using $dd_grey_med
DD_TEXT="cdd9e5FF"             # Using $dd_white

# i3lock configuration
i3lock --color=$DD_BACKGROUND --inside-color=$DD_BACKGROUND --ring-color=$DD_RING --insidewrong-color=$DD_BACKGROUND --ringwrong-color=$DD_RING_WRONG --insidever-color=$DD_BACKGROUND --ringver-color=$DD_RING_VERIFY --line-color=$DD_LINE --keyhl-color=$DD_RING_VERIFY --bshl-color=$DD_RING_WRONG --time-color=$DD_TEXT --date-color=$DD_TEXT --layout-color=$DD_TEXT --time-str="%H:%M:%S" --date-str="%A, %d %B %Y" --radius=120 --ring-width=10 --clock