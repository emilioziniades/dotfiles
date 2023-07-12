# STARTUP PROFILING

# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '
# logfile=$(mktemp zsh_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile
# setopt XTRACE

PROMPT='%F{yellow}%~%f %F{blue}%#%f '

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

export GPG_TTY=$(tty)

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export DOTNET_CLI_TELEMETRY_OPTOUT=1

ct() {
    cargo test $1 -- --nocapture --color=always
}

time-startup() {
    time zsh -i -c echo
}

# STARTUP PROFILING

# unsetopt XTRACE
# exec 2>&3 3>&-
