# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

# set sane options
zcomet load willghatch/zsh-saneopt

# zcomet load ohmyzsh plugins/ssh-agent
zcomet load --no-submodules prezto modules/history

zcomet load zsh-users/zsh-completions
zcomet load zsh-users/zsh-autosuggestions
zcomet load --no-submodules prezto modules/completion

zcomet load ohmyzsh plugins/gitfast
zcomet load --no-submodules prezto modules/archive

zcomet load zsh-users/zsh-history-substring-search

zcomet load Aloxaf/fzf-tab
zcomet load olets/zsh-abbr
zcomet load djui/alias-tips
zcomet load zdharma-continuum/fast-syntax-highlighting

# vi mode
ZVM_INIT_MODE=sourcing
zcomet load jeffreytse/zsh-vi-mode

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Vi
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

OS="$(uname)"
if [[ "$OS" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  export WHALEBREW_INSTALL_PATH=/home/linuxbrew/.linuxbrew/bin
fi

source ${HOME}/.local/share/sh/homebrew.sh
if [[ "$OS" == "Darwin" ]]; then
  eval "$($(homebrew_location)/bin/brew shellenv)"
fi

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

setopt pushd_ignore_dups
# setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.
# setopt PATH_DIRS            # Perform path search even on command names with slashes.
# setopt AUTO_MENU            # Show completion menu on a successive tab press.
# setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
# setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash.
# # unsetopt MENU_COMPLETE      # Do not autoselect the first completion entry.
# # unsetopt FLOW_CONTROL       # Disable start/stop characters in shell editor.
#
# # Defaults.
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
#
# # Use caching to make completion for commands such as dpkg and apt usable.
# zstyle ':completion::complete:*' use-cache on
# zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/prezto/zcompcache"
#
# # Case-insensitive (all), partial-word, and then substring completion.
# if zstyle -t ':prezto:module:completion:*' case-sensitive; then
#   zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#   setopt CASE_GLOB
# else
#   zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#   unsetopt CASE_GLOB
# fi
#
# # Group matches and describe.
# zstyle ':completion:*:*:*:*:*' menu select
# zstyle ':completion:*:matches' group 'yes'
# zstyle ':completion:*:options' description 'yes'
# zstyle ':completion:*:options' auto-description '%d'
# zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
# zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
# zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
# zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' verbose yes
#
# # Fuzzy match mistyped completions.
# zstyle ':completion:*' completer _complete _match _approximate
# zstyle ':completion:*:match:*' original only
# zstyle ':completion:*:approximate:*' max-errors 1 numeric
#
# # Increase the number of errors based on the length of the typed word. But make
# # sure to cap (at 7) the max-errors to avoid hanging.
# zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
#
# # Don't complete unavailable commands.
# zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
#
# # Array completion element sorting.
# zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
#
# # Directories
# zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
# zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
# zstyle ':completion:*' squeeze-slashes true

# Load user config from ~/.zsh.after
if [ -d $HOME/.zsh.after/ ]; then
  if [ "$(ls -A $HOME/.zsh.after/)" ]; then
    for config_file ($HOME/.zsh.after/*.zsh) source $config_file
  fi
fi
if [ -e /Users/ryansch/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/ryansch/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

zcomet compinit

if [ -n "$SETPWD" ]; then
  cd "$SETPWD"

  if [ -f Deskfile ]; then
    eval $(desk load)
  fi
fi

if [ -n "$RUN" ]; then
  eval "$RUN"
fi
