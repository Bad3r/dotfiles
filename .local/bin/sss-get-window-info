#!/bin/bash

aw=$(xdotool getactivewindow)
eval $(xwininfo -id "$aw" |
      sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" \
             -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" \
             -e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" \
             -e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" )
if [ "$entire" = true ]
then
    extents=$(xprop _NET_FRAME_EXTENTS -id "$aw" | grep "NET_FRAME_EXTENTS" | cut -d '=' -f 2 | tr -d ' ')
    bl=$(echo $extents | cut -d ',' -f 1) # width of left border
    br=$(echo $extents | cut -d ',' -f 2) # width of right border
    t=$(echo $extents | cut -d ',' -f 3)  # height of title bar
    bb=$(echo $extents | cut -d ',' -f 4) # height of bottom border

    let x=$x-$bl
    let y=$y-$t
    let w=$w+$bl+$br
    let h=$h+$t+$bb
fi
echo "$w"x"$h" $x,$y
