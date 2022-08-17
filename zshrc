#CONFIG

setopt inc_append_history histignorealldups share_history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

#ALIASES

alias ls='ls --color'
alias lsal='ls -alh --color'

alias diff='diff --color=always'

alias gi="git init"
alias gs="git status"
alias gl="git log --oneline --all"
alias gg="git log --oneline --graph --decorate --all"
alias glf="git log"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gca="git commit -am"
alias gp="git push -u origin main"

alias py="python"
alias ipy="ipython"
alias jn="jupyter notebook"

alias gr="go run"
alias gt="go test"
alias gtv="go test -v ."

alias view="nvim -R"
alias tmux="tmux -u"

alias v="nvim"
alias t="tmux"
alias ve="view"

# VARIABLES

export LC_ALL=C.UTF-8
export W_HOME=/mnt/c/Users/EmilioZiniades

#FUNCTIONS

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

# PATH 

export PATH="/usr/local/sbin:$PATH"
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"

if command -v gem &> /dev/null
then
    export PATH="/usr/local/opt/ruby/bin:$PATH"
    export PATH="$(gem environment gemdir)/bin:$PATH"
fi

if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi


# PROMPT

PROMPT='%F{yellow}%~%f %F{blue}%#%f '

# PYENV SHIMS

if command -v pyenv &> /dev/null
then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi


# ITERM2 

it2zsh=~/.iterm2_shell_integration.zsh
if [ "$TERM_PROGRAM" = "iTerm.app" ]
then
    if ! [[ -f $it2zsh ]]
    then
        curl -L https://iterm2.com/shell_integration/zsh -o $it2zsh &> /dev/null
    fi
    source $it2zsh
fi

# NVM 

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# start in tmux always
if [[ $TMUX == "" ]]
then
    tmux
fi
