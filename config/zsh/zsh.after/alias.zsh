nvim() {
	if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
		nvr -p "$@"
	else
		command nvim "$@"
	fi
}
alias vim="nvim"

alias ls="exa -g --git -b"
alias cd="z"
alias cdi="zi"

# mimic vim functions
alias :q='exit'

# moar bat
alias cat="bat"
# alias rg="batgrep"
alias man="batman"
alias watch="batwatch"

# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
