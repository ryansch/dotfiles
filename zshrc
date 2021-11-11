### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

###################################
# Additional annexes
###################################

zinit light-mode for \
    zdharma-continuum/z-a-meta-plugins

###################################
# Load Immediately
###################################

# Load starship theme
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# fzf
zinit pack"bgn-binary+keys" for fzf

# vi mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# set sane options
zinit light willghatch/zsh-saneopt

zinit lucid for OMZP::ssh-agent/ssh-agent.plugin.zsh
zinit lucid for PZTM::history

###################################
# Section 0a (First Turbo)
###################################

zinit wait"0a" lucid light-mode for \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf \
    PZTM::completion

  # as"completion" nocompile mv'*.zsh -> _git' reset \
  #   felipec/git-completion \

zinit ice svn wait"0a" lucid
zinit snippet OMZ::plugins/gitfast

zinit ice svn wait"0a" lucid as"null"
zinit snippet PZTM::archive


# history search with up/down arrows
bindkey -r '^[[A'
bindkey -r '^[[B'
function __bind_history_keys() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down

  # Vi
  bindkey -M vicmd "k" history-substring-search-up
  bindkey -M vicmd "j" history-substring-search-down
}
zinit ice wait"0a" lucid atload"!__bind_history_keys"
zinit load zsh-users/zsh-history-substring-search

###################################
# Section 0b (Second Turbo)
###################################

zinit wait"0b" lucid light-mode for \
 atload"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

###################################
# Section 2 (Load after prompt)
###################################

# zoxide
zinit ice wait"2" as"command" from"gh-r" lucid \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit load ajeetdsouza/zoxide



ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

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
