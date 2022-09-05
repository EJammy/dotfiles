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


# searches for matching commands when using up arrow... not working D:
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search


# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style:
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line


source ~/.config/_alias.sh
eval "$(starship init zsh)"

# TODO: detect terminal and switch prompt accordingly
# autoload -Uz promptinit
# promptinit
# promptfire
