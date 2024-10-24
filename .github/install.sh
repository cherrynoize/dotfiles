#!/bin/sh
# Installation script
# https://github.com/cherrynoize/dotfiles

cp -n ./initrc ~/.initrc # install configuration file
cp -n ./env ~/.env # install environment file
cp -r -n ../bin/* ~/bin # install binaries
fix-wpg-templates # symlink wpg templates
update-system # fetch latest updat e
