add_path() {
	case ":$PATH:" in
  		*":$1:"*) :;; # already there
  		*) PATH="$1:$PATH";; # or PATH="$PATH:$new_entry"
	esac
}

add_path "$HOME/.local/bin"

export BROWSER=chromium

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi
