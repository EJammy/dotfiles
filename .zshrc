# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=4000
SAVEHIST=20000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/connorcc/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


source ~/.config/_alias.sh
eval "$(starship init zsh)"
