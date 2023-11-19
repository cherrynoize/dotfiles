#!/bin/sh
# install script for:
# https://github.com/cherrynoize/dotfiles

# make all bin files executable
chmod +x ~/bin/*

# fix wpg templates symlinks
fix-wpg-templates

# fetch latest update
update-system
