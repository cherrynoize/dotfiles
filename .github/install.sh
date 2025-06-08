#!/bin/sh
# Installation script
# https://github.com/cherrynoize/dotfiles

cp -n ./initrc ~/.initrc # install configuration file
cp -n ./env ~/.env # install environment file
cp -r -n ../bin/* ~/bin # install binaries
fix-wal-templates # create wal template links
fix-wpg-templates # create wpg template links

sd ln -s bin/update-mirrorlist /usr/local/bin/update-mirrolist # make update-mirrorlist reachable for cron

update-system # fetch latest update
