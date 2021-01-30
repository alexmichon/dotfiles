#!/bin/bash

# -------
# HELPERS
# -------

log() {
	if [ "$verbose" == "true" ]; then
		echo "$@"
	fi
}

do_ln() {
	if [ "$force" == "true" ]; then
		ln -sf "$@"
	else
		ln -s "$@"
	fi
}

# --------
# DEPENDENCIES
# --------

dependencies=(
zsh \
vim \
tmux \
bspwm \
sxhkd \
alacritty \
polybar \
conky \vimrcvimrcvimrc
picom \
vdirsyncer \
khal \
fzf \
rg \
xdotool \
xrectsel \
notify-send.py \
youtube-dl \
ctags \
cscope \
firefox \
spotify \
blockify p
)

check_dependencies() {
	for d in "${dependencies[@]}"; do
		if ! command -v $d &> /dev/null; then
			echo "$d is not installed"
		fi
	done

	if [ "$(fc-list "Ubuntu Mono Nerd Font" | wc -l)" -eq "0" ]; then
		echo "Ubuntu Mono Nerd Font is not installed"
	fi
}

# --------
# DOTFILES
# --------

install_shell() {
	if [ ! -d $dotfiles_dir/shell ]; then
		return 0
	fi

	log "Installing shell dotfiles:"

	for f in $(ls $dotfiles_dir/shell); do
		log "* Linking $install_dir/.$f"
		do_ln $dotfiles_dir/shell/$f $install_dir/.$f
	done
}

install_bash() {
	if [ ! -d $dotfiles_dir/bash ]; then
		return 0
	fi

	log "Installing bash dotfiles:"

	for f in $(ls $dotfiles_dir/bash); do
		log "* Linking $install_dir/.$f"
		do_ln $dotfiles_dir/bash/$f $install_dir/.$f
	done
}

install_zsh() {
	if [ ! -d $dotfiles_dir/zsh ]; then
		return 0
	fi

	log "Installing zsh dotfiles:"

	for f in $(ls $dotfiles_dir/zsh); do
		log "* Linking $install_dir/.$f"
		do_ln $dotfiles_dir/zsh/$f $install_dir/.$f
	done

	log "Installing zsh plugins:"
	if [ ! -d $install_dir/.zsh/zsh-autosuggestions/ ]; then
		log "* zsh-autosuggestions"
		git clone -q https://github.com/zsh-users/zsh-autosuggestions $install_dir/.zsh/zsh-autosuggestions
	fi
	if [ ! -d $install_dir/.zsh/zsh-syntax-highlighting/ ]; then
		log "* zsh-syntax-highlighting"
		git clone -q https://github.com/zsh-users/zsh-syntax-highlighting $install_dir/.zsh/zsh-syntax-highlighting
	fi
}

install_x11() {
	if [ ! -d $dotfiles_dir/x11 ]; then
		return 0
	fi

	log "Installing x11 dotfiles:"

	log "* Linking $install_dir/.xinitrc"
	do_ln $dotfiles_dir/x11/xinitrc $install_dir/.xinitrc
}

install_git() {
	if [ ! -d $dotfiles_dir/git ]; then
		return 0
	fi

	log "Installing git dotfiles:"

	for f in $(ls $dotfiles_dir/git); do
		log "* Linking $install_dir/.$f"
		do_ln $dotfiles_dir/git/$f $install_dir/.$f
	done
}

install_vim() {
	if [ ! -d $dotfiles_dir/vim ]; then
		return 0
	fi

	log "Installing vim dotfiles:"

	log "* Linking $install_dir/.vimrc"
	do_ln $dotfiles_dir/vim/vimrc $install_dir/.vimrc

	mkdir -p $install_dir/.vim/colors
	log "* Linking $install_dir/.vim/colors/myscheme.vim"
	do_ln $dotfiles_dir/vim/colors/myscheme.vim $install_dir/.vim/colors/myscheme.vim

	vim +PluginInstall +qall

	if [ -d $dotfiles_dir/vim/patches ]; then
		for p in $(ls $dotfiles_dir/vim/patches); do
			log "* Patching $p"
			patch -s -p0 -d $install_dir/.vim/bundle/ < $dotfiles_dir/vim/patches/$p
		done
	fi

	if [ -d $dotfiles_dir/vim/ftplugin ]; then
		for f in $(ls $dotfiles_dir/vim/ftplugin); do
			log "* Linking $install_dir/.vim/ftplugin/$f"
		done
	fi
}

install_tmux() {
	if [ ! -d $dotfiles_dir/tmux ]; then
		return 0
	fi

	log "Installing tmux dotfiles:"

	log "* Linking $install_dir/.tmux.conf"
	do_ln $dotfiles_dir/tmux/tmux.conf $install_dir/.tmux.conf

	log "Installing tmux plugins:"
	if [ ! -d $install_dir/.tmux/plugins/tpm ]; then
		mkdir -p $install_dir/.tmux/plugins
		git clone https://github.com/tmux-plugins/tpm $install_dir/.tmux/plugins/tpm
		$install_dir/.tmux/plugins/tpm/bin/install_plugins
	fi
}

install_bin() {
	if [ ! -d $dotfiles_dir/bin ]; then
		return 0
	fi

	log "Installing bin files:"

	if [ ! -d $install_dir/.local/bin ]; then
		mkdir -p $install_dir/.local/bin
	fi

	for f in $(ls $dotfiles_dir/bin); do
		log "* Linking $install_dir/.local/bin/$f"
		do_ln $dotfiles_dir/bin/$f $install_dir/.local/bin/$f
	done
}

install_data() {
	if [ ! -d $dotfiles_dir/data ]; then
		return 0
	fi

	log "Installing data files:"

	if [ ! -d $install_dir/.local/data ]; then
		mkdir -p $install_dir/.local/data
	fi

	for f in $(ls $dotfiles_dir/data); do
		log "* Linking $install_dir/.local/data/$f"
		do_ln $dotfiles_dir/data/$f $install_dir/.local/data/$f
	done
}

install_python() {
	if [ ! -d $dotfiles_dir/python ]; then
		return 0
	fi

	log "Installing python dotfiles:"

	mkdir -p $install_dir/.python
	log "* Linking $install_dir/.python/pythonrc.py"
	do_ln $dotfiles_dir/python/pythonrc.py $install_dir/.python/pythonrc.py
}

install_alacritty() {
	if [ ! -d $dotfiles_dir/alacritty ]; then
		return 0
	fi

	log "Installing alacritty dotfiles:"

	mkdir -p $install_dir/.config/alacritty
	log "* Linking $install_dir/.config/alacritty/alacritty.yml"
	do_ln $dotfiles_dir/alacritty/alacritty.yml $install_dir/.config/alacritty/alacritty.yml
}

install_bspwm() {
	if [ ! -d $dotfiles_dir/bspwm ]; then
		return 0
	fi

	log "Installing bspwm dotfiles:"

	mkdir -p $install_dir/.config/bspwm
	for f in $(ls -p $dotfiles_dir/bspwm | grep -v /); do
		log "* Linking $install_dir/.config/bspwm/$f"
		do_ln $dotfiles_dir/bspwm/$f $install_dir/.config/bspwm/$f
	done

	if [ -d $dotfiles_dir/bspwm/scripts ]; then
		mkdir -p $install_dir/.config/bspwm/scripts
		for f in $(ls $dotfiles_dir/bspwm/scripts); do
			log "* Linking $install_dir/.config/bspwm/scripts/$f"
			do_ln $dotfiles_dir/bspwm/scripts/$f $install_dir/.config/bspwm/scripts/$f
		done
	fi
}

install_sxhkd() {
	if [ ! -d $dotfiles_dir/sxhkd ]; then
		return 0
	fi

	log "Installing sxhkd dotfiles:"

	mkdir -p $install_dir/.config/sxhkd
	for f in $(ls -p $dotfiles_dir/sxhkd | grep -v /); do
		log "* Linking $install_dir/.config/sxhkd/$f"
		do_ln $dotfiles_dir/sxhkd/$f $install_dir/.config/sxhkd/$f
	done

	do_ln $install_dir/.config/sxhkd/sxhkdrc $install_dir/.config/sxhkd/sxhkdrc-default

	if [ -d $dotfiles_dir/sxhkd/scripts ]; then
		mkdir -p $install_dir/.config/sxhkd/scripts
		for f in $(ls $dotfiles_dir/sxhkd/scripts); do
			log "* Linking $install_dir/.config/sxhkd/scripts/$f"
			do_ln $dotfiles_dir/sxhkd/scripts/$f $install_dir/.config/sxhkd/scripts/$f
		done
	fi
}

install_picom() {
	if [ ! -d $dotfiles_dir/picom ]; then
		return 0
	fi

	log "Installing picom dotfiles:"

	mkdir -p $install_dir/.config/picom
	log "* Linking $install_dir/.config/picom.conf"
	do_ln $dotfiles_dir/picom/picom.conf $install_dir/.config/picom/picom.conf
}

install_rofi() {
	if [ ! -d $dotfiles_dir/rofi ]; then
		return 0
	fi

	log "Installing rofi dotfiles:"

	mkdir -p $install_dir/.config/rofi
	log "* Linking $install_dir/.config/rofi/config.rasi"
	do_ln $dotfiles_dir/rofi/config.rasi $install_dir/.config/rofi/config.rasi

	if [ -d $dotfiles_dir/rofi/scripts ]; then
		mkdir -p $install_dir/.config/rofi/scripts
		for f in $(ls $dotfiles_dir/rofi/scripts); do
			log "* Linking $install_dir/.config/rofi/scripts/$f"
			do_ln $dotfiles_dir/rofi/scripts/$f $install_dir/.config/rofi/scripts/$f
		done
	fi
}

install_polybar() {
	if [ ! -d $dotfiles_dir/rofi ]; then
		return 0
	fi

	log "Installing polybar dotfiles:"

	mkdir -p $install_dir/.config/polybar
	log "* Linking $install_dir/.config/polybar/config"
	do_ln $dotfiles_dir/polybar/config $install_dir/.config/polybar/config
	do_ln $dotfiles_dir/polybar/launch.sh $install_dir/.config/polybar/launch.sh

	if [ -d $dotfiles_dir/polybar/scripts ]; then
		mkdir -p $install_dir/.config/polybar/scripts
		for f in $(ls $dotfiles_dir/polybar/scripts); do
			log "* Linking $install_dir/.config/polybar/scripts/$f"
			do_ln $dotfiles_dir/polybar/scripts/$f $install_dir/.config/polybar/scripts/$f
		done
	fi
}

install_conky() {
	if [ ! -d $dotfiles_dir/conky ]; then
		return 0
	fi

	log "Installing conky dotfiles:"

	mkdir -p $install_dir/.config/conky
	for f in $(ls -p $dotfiles_dir/conky | grep -v /); do
		log "* Linking $install_dir/.config/conky/$f"
		do_ln $dotfiles_dir/conky/$f $install_dir/.config/conky/$f
	done

	if [ -d $dotfiles_dir/conky/scripts ]; then
		mkdir -p $install_dir/.config/conky/scripts
		for f in $(ls $dotfiles_dir/conky/scripts); do
			log "* Linking $install_dir/.config/conky/scripts/$f"
			do_ln $dotfiles_dir/conky/scripts/$f $install_dir/.config/conky/scripts/$f
		done
	fi
}

install_all() {
	if [ ! -d "$install_dir" ]; then
		echo "Error: Directory $install_dir doesn't exist"
		exit 1
	fi

	log "Installing dotfiles in $install_dir"
	install_shell
	install_bash
	install_zsh
	install_x11
	install_git
	install_vim
	install_tmux
	install_bin
	install_data
	install_python
	install_alacritty
	install_bspwm
	install_sxhkd
	install_picom
	install_rofi
	install_polybar
	install_conky
}

# ----
# MAIN
# ----

dotfiles_dir="$(dirname $(readlink -f $0))"
install_dir="$HOME"
verbose=false
force=false
action=""

while [ -n "$1" ]; do
	case "$1" in
		-i|--install-dir)
			install_dir="$2"
			shift
			;;
		-v|--verbose)
			verbose=true
			;;
		-f|--force)
			force=true
			;;
		install)
			install_all
			;;
		dependencies)
			check_dependencies
			;;
		*)
			echo "Unknown argument: $1"
			exit 1
			;;
	esac

	shift
done
