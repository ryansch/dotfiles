#!/usr/bin/env bash

set -euo pipefail

if [[ $(uname) != "Darwin" ]]; then
  log_warn "this script requires MacOS (darwin); skipping."
  exit 0
fi

# HOWTO:
# - https://www.sethvargo.com/replace-icons-osx
# - https://github.com/DinkDonk/kitty-icon#installation
cp ~/.dotfiles/config/kitty/kitty.icns /Applications/kitty.app/Contents/Resources/kitty.icns
rm /var/folders/*/*/*/com.apple.dock.iconcache
touch /Applications/kitty.app
killall Dock && killall Finder
