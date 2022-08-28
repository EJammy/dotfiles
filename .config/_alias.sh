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

trash()
{
	cfast foo
}

autocommit()
{
	git status || return
	echo -n "Commit and push changes? [y/n]: "
	read REPLY
	echo    # (optional) move to a new line

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		git add . && git commit -am "Auto commit on $(date --utc +'%c')" && git push
	else
		echo "No action"
	fi
}


mkcd()
{
	#if [[ -d $1 ]]
	mkdir $1 && cd $1
}

ssh_mc_server=167.99.31.53

