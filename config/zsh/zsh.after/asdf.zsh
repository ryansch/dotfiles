OS="$(uname)"
if [[ "$OS" == "Linux" ]]; then
	if [ -f /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh ]; then
		echo "DO NOT USE ASDF INSTALLED IN LINUXBREW"
		echo "Not loading asdf!"
	elif [ -f "$HOME/.asdf/asdf.sh" ]; then
		. "$HOME/.asdf/asdf.sh"
  fi
fi
