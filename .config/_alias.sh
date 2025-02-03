alias wiki='vim -c "VimwikiIndex"'
alias csafe='g++ -std=c++17 -Wshadow -Wall -DLOCAL -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG -g'
alias cfast='g++ -std=c++17 -Wshadow -Wall -DLOCAL -O3'

# expands alias for sudo
alias sudo='sudo '

alias sudol='sudo bash -c'

alias ls='ls --color'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias mv='mv -iv'
alias cp='cp -iv'

alias dotgit='git --work-tree=$HOME --git-dir=$HOME/.dotfiles-git'
alias g='git'


gitauto()
{
	gitcmd='git'
	[ $# -eq 1 ] && gitcmd="eval $1"
	cmd=( ${=gitcmd} )
	$cmd status || return
	echo -n "Commit and push changes? [y/n]: "
	read REPLY
	echo    # (optional) move to a new line

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		$cmd commit -am "Auto commit on $(date --utc +'%c')" && git push
	else
		echo "No action"
	fi
}

mkcd()
{
	#if [[ -d $1 ]]
	mkdir $1 && cd $1
}

add-alias()
{
	echo alias $1=\"$2\" >> ~/.config/_alias.sh
	source ~/.config/_alias.sh
}

alias venv-start="source .venv/bin/activate"
alias py="python"
