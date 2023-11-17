# if you want to profile zsh startup times, see: https://esham.io/2018/02/zsh-profiling

PROMPT='%F{yellow}%~%f %F{blue}%#%f '

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

export GPG_TTY=$(tty)

export GOPATH=$HOME/go/bin
export PATH="$GOPATH:$PATH"

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export DOTNET_CLI_TELEMETRY_OPTOUT=1

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
