#!/bin/bash

set -euo pipefail

# Clone to /tmp/nvims and run from there.
git clone https://github.com/Traap/nvims /tmp/traap/nvims
cd /tmp/traap/nvims

# Copy files to their production locations.
cp -v nvims "$HOME"/.local/bin/.
chmod -v +x "$HOME"/.local/bin/nvims

# Create config directory and copy files there.
mkdir -p "$HOME"/.config/nvims
cp -v neovim_distros "$HOME"/.config/nvims/.

# Cleanup temporary directory.
rm -rfv /tmp/traap
