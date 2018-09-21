#!/bin/bash
# a simple script to create syslinks for my dotfiles.
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.Xresources ~/.Xresources

ln -sf  ~/dotfiles/.config/i3/compton.conf ~/.config/i3/compton.conf
ln -sf  ~/dotfiles/.config/i3/config ~/.config/i3/config
ln -sf  ~/dotfiles/.config/i3/config ~/.config/i3/lock.sh

ln -sf  ~/dotfiles/.config/polybar/config ~/.config/polybar/config
ln -sf  ~/dotfiles/.config/polybar/launch.sh ~/.config/polybar/launch.sh
chmod 755 ~/.config/polybar/launch.sh

ln -sf  ~/dotfiles/.config/neofetch/config.conf ~/.config/neofetch/config.conf

ln -sf  ~/dotfiles/.config/ranger/rc.conf ~/.config/ranger/rc.conf
ln -sf ~/dotfiles/.config/ranger/scope.sh ~/.config/ranger/scope.sh
chmod +755 ~/.config/ranger/scope.sh

ln -sf ~/dotfiles/.config/rofi ~/.config/rofi/config
