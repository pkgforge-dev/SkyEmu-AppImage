#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q skyemu | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/skylersaleh/SkyEmu/refs/heads/dev/src/resources/icons/icon-nobg.png
export DESKTOP=/usr/share/applications/skyemu.desktop
export STARTUPWMCLASS=
export DEPLOY_PIPEWIRE=1

# Deploy dependencies
quick-sharun /usr/bin/SkyEmu

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
