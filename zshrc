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

alias cr="cargo run"

alias view="nvim -R"
alias tmux="tmux -u"

alias v="nvim"
alias t="tmux"
alias ve="view"

alias tree="tree --gitignore"

alias k="kubectl"
# VARIABLES

export LC_ALL=en_US.UTF-8

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

# git push current branch
gpcb() {
    git push -u origin $(git branch --show-current)
}

# git delete current branch
gdcb() {
    git push -d origin $(git branch --show-current)
}

# cargo test
ct() {
    cargo test $1 -- --nocapture --color=always
}

# PATH 

export PATH="/usr/local/sbin:$PATH"
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:/Users/emilioziniades/.dotnet/tools"

# ruby
if command -v gem &> /dev/null
then
    export PATH="/usr/local/opt/ruby/bin:$PATH"
    export PATH="$(gem environment gemdir)/bin:$PATH"
fi

#rust
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

export PATH="$PATH:$HOME/.local/bin"

# PROMPT

PROMPT='%F{yellow}%~%f %F{blue}%#%f '

# PYENV SHIMS

if command -v pyenv &> /dev/null
then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# NVM 

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm


# start in tmux always
if [[ $TMUX == "" ]]
then
    tmux
fi

if  command -v vt &> /dev/null
then
    vt login
fi

# GPG

export GPG_TTY=$(tty)

# KEYBINDS

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
