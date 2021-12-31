export FLYCTL_INSTALL="/Users/ryansch/.fly"

typeset -U path
path=(~/bin ~/.local/bin /opt/homebrew/opt/python@3.9/libexec/bin "$FLYCTL_INSTALL/bin" /opt/homebrew/opt/ruby/bin /opt/homebrew/lib/ruby/gems/3.0.0/bin "$path[@]" /usr/local/sbin /usr/local/bin)

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
