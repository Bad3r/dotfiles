#!/bin/bash
# a simple script to create syslinks for my dotfiles.

# bash config
ln -sf ~/dotfiles/.bashrc ~/.bashrc

# zsh config
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf $DOTFILES/.alias.zsh $HOME/

# Xresources config
ln -sf ~/dotfiles/.Xresources ~/.Xresources

# compton config
ln -sf  ~/dotfiles/.config/i3/compton.conf ~/.config/i3/compton.conf

# i3wm confing
ln -sf  ~/dotfiles/.config/i3/config ~/.config/i3/config
ln -sf  ~/dotfiles/.config/i3/lock.sh ~/.config/i3/lock.sh
chmod 755 ~/.config/i3/lock.sh

# polybar config
ln -sf  ~/dotfiles/.config/polybar/config ~/.config/polybar/config
ln -sf  ~/dotfiles/.config/polybar/launch.sh ~/.config/polybar/launch.sh
chmod 755 ~/.config/polybar/launch.sh

# neofetch config
ln -sf  ~/dotfiles/.config/neofetch/config.conf ~/.config/neofetch/config.conf

# ranger config
ln -sf  ~/dotfiles/.config/ranger/rc.conf ~/.config/ranger/rc.conf
ln -sf ~/dotfiles/.config/ranger/scope.sh ~/.config/ranger/scope.sh
chmod 755 ~/.config/ranger/scope.sh

# rofi config
ln -sf ~/dotfiles/.config/rofi ~/.config/rofi/config

# GTK 3 and 2 config, better use lxappearance instead
ln -sf ~/dotfiles/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini
ln -sf ~/dontfiles/.gtkrc-2.0 ~/.gtkrc-2.0

# set color scheme using pywal
ln -sf ~/dotfiles/Pictures/Wal/bg1.jpg ~/Pictures/Wal/bg1.jpg
wal -i ~/Pictures/Wal/bg1.jpg
