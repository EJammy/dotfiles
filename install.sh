#!/bin/sh

install() {
	target=$HOME/$1
	if [[ -L $target ]]; then
		echo "Found existing symlink at" $target
	else
		if [[ -e $target ]]; then
			mv -vi $target $target.bak
		fi
		ln -svi $HOME/dotfiles/$1 $target
	fi
}

install .zshrc
install .zshenv
install .bashrc
install .config/nvim
install .config/systemd/user/_rclone-mount.service
