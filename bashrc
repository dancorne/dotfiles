
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

EDITOR=vim
TERM=screen-256color

export TERM EDITOR

#Pass through for Ctrl-S to work in vim
stty -ixon
