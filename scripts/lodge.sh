#!/bin/bash
intern="eDP-1-1"
extern0="DP-1"
extern1="HDMI-0"
res1="2560x1440"
res0="1920x1080"

if xrandr | grep "$extern0 disconnected"; then
	xrandr --output "$extern0" --off --output "$extern1" --of --output "$intern" --auto
else
	xrandr --output "$extern0" --primary --mode $res1 --pos 1920x139 --rotate normal --output "$extern1" --mode $res0 --pos 4480x0 --rotate right --output "$intern" --mode $res0 --pos 0x371 --rotate normal
fi
