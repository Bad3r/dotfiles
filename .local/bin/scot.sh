#! /bin/bash
scrot '%S.png' -e 'mv $f $$(xdg-user-dir)/Pictures/screenshot-%S-$wx$h.png; feh $$(xdg-user-dir)/Pictures/screenshot-%S-$wx$h.png'
