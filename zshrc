# STARTUP PROFILING

# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '
# logfile=$(mktemp zsh_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile
# setopt XTRACE
#

PROMPT='%F{yellow}%~%f %F{blue}%#%f '

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

export GPG_TTY=$(tty)

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

mkcd() {
    mkdir -p "$1" && cd "$1"
}

venv() {
    python -m venv venv
    source venv/bin/activate
}

activate() {
    source venv/bin/activate
}

# git push current branch
gpcb() {
    git push -u origin $(git branch --show-current)
}

# git delete current branch
gdcb() {
    git push -d origin $(git branch --show-current)
}

ct() {
    cargo test $1 -- --nocapture --color=always
}

hist() {
    history 0 | grep $1
}

# tms() {
#     ~/dotfiles/bin/tmux-sessionizer.sh
# }

vpn() {
    ~/dotfiles/bin/vpn.sh $1 $2
}

time-startup() {
    time zsh -i -c echo
}

pbcopy() {
    xclip -selection clipboard
}

# PATH 

#rust
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# STARTUP PROFILING

# unsetopt XTRACE
# exec 2>&3 3>&-
