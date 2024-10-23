#!/bin/sh
# Installation script
# https://github.com/cherrynoize/dotfiles

cp -n ./initrc ~/.initrc # install configuration file
cp -r -n ../bin/* ~/bin # install binary files
fix-wpg-templates # symlink wpg templates
update-system # fetch latest updat e
