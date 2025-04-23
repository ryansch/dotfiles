alias vim="nvim"

alias ls="eza -g --git -b"
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

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias devreset="flox services stop; docker compose down -v && docker compose up -d && bundle && yarn install && sleep 1 && rails dev:prime"
alias pumareset="puma-dev -stop && puma-dev -install"

alias flogs="flox services logs --follow"
alias fstart="flox services start"
alias frestart="flox services restart"
alias fstop="flox services stop"
alias fstatus="flox services status"
alias fps="flox services status"
