#! /usr/bin/env bash

# Electron Apps
# For Electron apps do not link the complete directory. Only specific files.
# e.g. code, VSCodium, Kiro, ...
## Logseq
ln -s "$DOTFILES/conf/Logseq/configs.edn" "$XDG_CONFIG_HOME/Logseq/configs.edn"
ln -s "$DOTFILES/conf/Logseq/Custom Dictionary.txt" "$XDG_CONFIG_HOME/Logseq/Custom Dictionary.txt"
ln -s "$DOTFILES/conf/Logseq/Custom Dictionary.txt.backup" "$XDG_CONFIG_HOME/Logseq/Custom Dictionary.txt.backup"

## Obsidian
ln -s "$DOTFILES/conf/obsidian/Custom Dictionary.txt" "$XDG_CONFIG_HOME/Logseq/Custom Dictionary.txt"
ln -s "$DOTFILES/conf/obsidian/Custom Dictionary.txt.backup" "$XDG_CONFIG_HOME/Logseq/Custom Dictionary.txt.backup"


