#!/bin/bash
chattr -i /sys/firmware/efi/efivars/Boot0000-8be4df61-93ca-11d2-aa0d-00e098032b8c

echo -ne "\x07\x00Microsoft\x20\x00" | iconv -f UTF-8 -t UTF-16LE > Boot0000-8be4df61-93ca-11d2-aa0d-00e098032b8c

systemctl reboot
