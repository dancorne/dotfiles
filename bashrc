
# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
 [[ -f /etc/bash_completion ]] && . /etc/bash_completion


# virtualenvs
export PROJECT_HOME=$HOME/code
export WORKON_HOME=$PROJECT_HOME/.venv
[[ -f  /usr/bin/virtualenvwrapper.sh ]] && . /usr/bin/virtualenvwrapper.sh

# Aliases
#
# Some people use a different file for aliases
 if [ -f "${HOME}/.bash_aliases" ]; then
   source "${HOME}/.bash_aliases"
 fi

# Environment variables
HISTSIZE=500000
HISTFILESIZE=5000000
EDITOR=vim
TERM=screen-256color
ANSIBLE_NOCOWS=1

export TERM EDITOR HISTSIZE HISTFILESIZE ANSIBLE_NOCOWS

# Change prompt after non-zero exit codes to red
__prompt_command() {
    local EXIT="$?"
    #local REMINDER=$(sort --random-sort .reminders | head -1)
    #PS1="${REMINDER}\n"
    PS1=""

    local RESET='\[\e[0m\]'
    local RED='\[\e[0;31m\]'

    if [ $EXIT != 0 ]; then
        PS1+="${RED}"      # Add red if exit code non 0
    fi

    PS1+="[\u@\h \W]${RESET}\$ "
}
PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

# Search
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Complete SSH hosts
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

#Pass through for Ctrl-S to work in vim
stty -ixon
