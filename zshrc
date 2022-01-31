
#CONFIG

setopt inc_append_history
setopt share_history

#ALIASES

alias ls='ls --color'
alias p="python"
alias gr="go run"
alias gt="go test"
alias go118="go1.18beta1"
alias v="nvim -p"
alias ve="nvim -Rp"
alias jn="jupyter notebook"

# PROMPT

PROMPT='%F{046}%n%f:%F{033}%~%f %F{033}%#%f '

# PYENV SHIMS

if command -v pyenv &> /dev/null
then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

#FUNCTIONS

mkcd() {
    mkdir -p "$1" && cd "$1"
}

tmx() {
    SES="devenv"
    tmux new-session -d -s $SES
    tmux split-window -d -t $SES: -h -p30
    tmux attach-session -t $SES
}


