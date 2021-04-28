#! /bin/bash

update_status=$(pacman -Qu | awk 'END { print (NR == 0 ? "System up to date" : NR " package" (NR > 1 ? "s" : "")); }')

echo "$update_status"