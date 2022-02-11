
#CONFIG

setopt inc_append_history histignorealldups share_history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

#ALIASES

alias ls='ls --color'
alias lsal='ls -alh --color'

alias gi="git init"
alias gs="git status"
alias gl="git log --pretty=oneline"
alias glf="git log"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gca="git add . && git commit -m"
alias gp="git push -u origin main"

alias p="python"
alias jn="jupyter notebook"

alias go="go1.18beta2"
alias gr="go run"
alias gt="go test"
alias gtv="go test -v ."

alias v="nvim -p"
alias=vi="nvim -p"
alias vim="nvim -p"
alias ve="nvim -Rp"
alias view="nvim -Rp"

# VARIABLES

export LC_ALL=C

# PATH 

export PATH="/usr/local/sbin:$PATH"
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"

if command -v gem &> /dev/null
then
    export PATH="/usr/local/opt/ruby/bin:$PATH"
    export PATH="$(gem environment gemdir)/bin:$PATH"
fi


# PROMPT

PROMPT='%F{046}%n@%m%f:%F{033}%~%f %F{033}%#%f '

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

# ITERM2 

it2zsh=~/.iterm2_shell_integration.zsh
if [ "$TERM_PROGRAM" = "iTerm.app" ]
then
    if ! [ -f $it2zsh ]
    then
        echo "iterm script not exist"
        curl -L https://iterm2.com/shell_integration/zsh -o $it2zsh &> /dev/null
    fi
    source $it2zsh
fi

# NEOFETCH

if command -v neofetch &> /dev/null
then
    neofetch
fi
