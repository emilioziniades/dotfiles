#!/usr/bin/env zsh
# shamelessly yoinked from https://esham.io/2018/02/zsh-profiling
#
# note on how to use: 
# - add the following to the top of your zshrc
#
# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '
# logfile=$(mktemp zsh_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile
# setopt XTRACE
#
# - add the following to the bottom
#
# unsetopt XTRACE
# exec 2>&3 3>&-
#
# - open a new zsh shell
# - run: ./sort_timings.zsh zsh_profile.abcd1234 | head

typeset -a lines
typeset -i prev_time=0
typeset prev_command

while read line; do
    if [[ $line =~ '^.*\+([0-9]{10})\.([0-9]{6})[0-9]* (.+)' ]]; then
        integer this_time=$match[1]$match[2]

        if [[ $prev_time -gt 0 ]]; then
            time_difference=$(( $this_time - $prev_time ))
            lines+="$time_difference $prev_command"
        fi

        prev_time=$this_time

        local this_command=$match[3]
        if [[ ${#this_command} -le 80 ]]; then
            prev_command=$this_command
        else
            prev_command="${this_command:0:77}..."
        fi
    fi
done < ${1:-/dev/stdin}

print -l ${(@On)lines}
