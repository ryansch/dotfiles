# source ${HOME}/.local/share/sh/homebrew.sh
# homebrew_dir=$(homebrew_location)

typeset -U path
path=(~/.local/bin "$path[@]" /usr/local/sbin /usr/local/bin)

export EDITOR="$(which nvim)"
export NODE_PATH=/usr/local/lib/node_modules
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"

export GITHUB_USER='ryansch'
export GOSS_PATH=~/bin/goss-linux-amd64
export GPG_TTY=$(tty)

export SKETCHBOOK_DIR=~/dev/arduino
export KALEIDOSCOPE_DIR=~/dev/arduino/Kaleidoscope

export COMPOSE_DOCKER_CLI_BUILD=1

export GLAMOUR_STYLE=dark

export XDG_DATA_HOME=${HOME}/.local/share
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_STATE_HOME=${HOME}/.local/state
export XDG_DATA_DIRS=/usr/local/share:/usr/share # Should I add /opt/homebrew/share?
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_RUNTIME_DIR=${HOME}/.local/run
# No XDG env var for it, but binaries go in ~/.local/bin
