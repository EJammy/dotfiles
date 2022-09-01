install() {
	target=$HOME/$1
	[[ -e $target ]] && mv -vi $target $target.bak
	ln -svi $HOME/dotfiles/$1 $target
}

install .zshrc
install .bashrc
install .config/nvim
install .config/systemd/user/_rclone-mount.service
