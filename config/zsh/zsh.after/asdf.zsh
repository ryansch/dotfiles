OS="$(uname)"
if [[ "$OS" == "Linux" ]]; then
	if [ -f /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh ]; then
		. /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh
	elif [ -f "$HOME/.asdf/asdf.sh" ]; then
		. "$HOME/.asdf/asdf.sh"
  fi
fi
