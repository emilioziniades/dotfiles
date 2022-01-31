
#CONFIG

setopt inc_append_history
setopt share_history


#ALIASES

alias gr="go run"
alias gt="go test"
alias go118="go1.18beta1"
alias jn="jupyter notebook"
alias p="python"
alias ls='ls --color'
alias v="nvim -p"
alias ve="nvim -Rp"

# Path 
export PATH="$PATH:/usr/local/sbin"
export GOPATH="/Users/emilioziniades/go"
export PATH="$PATH:$GOPATH/bin"
export XDG_CONFIG_HOME="~/dotfiles" #for neovim
# Prompt
PROMPT='%F{046}%n%f:%F{033}%~%f %F{033}%#%f '

# SHIMS
#Pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

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


