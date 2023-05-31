# STARTUP PROFILING

# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '
# logfile=$(mktemp zsh_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile
# setopt XTRACE

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
alias ve="nvim -R"
alias t="tmux"
alias c="clear && tmux clear-history"

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

ct() {
    cargo test $1 -- --nocapture --color=always
}

load() {
    case $1 in
        nvm)
            export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
            ;;
        pyenv)
            if command -v pyenv &> /dev/null
            then
                eval "$(pyenv init --path)"
                eval "$(pyenv init -)"
            fi
            ;;
        *)
            echo "I don't know how to load $1"
    esac
}

hist() {
    history 0 | grep $1
}

#tmux-sessionizer
tms() {
    ~/dotfiles/bin/tmux-sessionizer.sh
}

vpn() {
    ~/dotfiles/bin/vpn.sh $1 $2
}

time-startup() {
    time zsh -i -c echo
}

# PATH 

export PATH="/usr/local/sbin:$PATH"
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:/Users/emilioziniades/.dotnet/tools"
export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools
export DOTNET_ROOT=$HOME/.dotnet

# ruby
if command -v gem &> /dev/null
then
    export PATH="/usr/local/opt/ruby/bin:$PATH"
    export PATH="/Library/Ruby/Gems/2.6.0/bin:$PATH"
fi

#rust
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

export PATH="$PATH:$HOME/.local/bin"

# PROMPT

PROMPT='%F{yellow}%~%f %F{blue}%#%f '

# GPG

export GPG_TTY=$(tty)

# KEYBINDS

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word


# STARTUP PROFILING

# unsetopt XTRACE
# exec 2>&3 3>&-
