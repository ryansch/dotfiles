OS="$(uname)"
if [[ "$OS" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  export WHALEBREW_INSTALL_PATH=/home/linuxbrew/.linuxbrew/bin
fi

if [[ "$OS" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
