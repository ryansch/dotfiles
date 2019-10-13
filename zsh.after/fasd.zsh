alias -L v > /dev/null
if [[ $? -eq 0 ]]; then
  alias v='f -e mvim'
fi
