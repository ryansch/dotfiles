homebrew_location() {
	if [ -d /opt/homebrew ]; then
		echo "/opt/homebrew"
	else
		echo "/usr/local"
	fi
}
