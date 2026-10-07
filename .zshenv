# export ZDOTDIR

export EDITOR="nvim"
# export PATH=
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
if (( $+commands[nproc] )); then
  export MAKEFLAGS="--jobs=$(nproc)"
elif [[ -x /usr/sbin/sysctl ]]; then
  export MAKEFLAGS="--jobs=$(/usr/sbin/sysctl -n hw.ncpu)"
fi

[[ -f ~/.config/secrets.sh ]] && source ~/.config/secrets.sh
