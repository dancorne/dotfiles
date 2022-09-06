
# Start up Starship
eval "$(starship init bash)"

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
 [[ -f /etc/bash_completion ]] && . /etc/bash_completion
 [[ -f $HOME/etc/bash_aliases ]] && . $HOME/etc/bash_aliases

export GOPATH=~/go
export PATH=$PATH:$HOME/bin:$GOPATH/bin:$HOME/.local/bin


# virtualenvs
export PROJECT_HOME=$HOME/code
export WORKON_HOME=$PROJECT_HOME/.venv
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
[[ -f  $HOME/.local/bin/virtualenvwrapper_lazy.sh ]] && . $HOME/.local/bin/virtualenvwrapper_lazy.sh

# AWS
export AWS_VAULT_KEYCHAIN_NAME=login
complete -C /usr/local/bin/aws_completer aws aws-vault
_aws-vault_bash_autocomplete() {
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$( ${COMP_WORDS[0]} --completion-bash "${COMP_WORDS[@]:1:$COMP_CWORD}" )
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _aws-vault_bash_autocomplete -o default aws-vault

export AWS_VAULT_PROMPT=osascript
export AWS_SDK_LOAD_CONFIG=1

# Aliases
#
# Some people use a different file for aliases
 if [ -f "${HOME}/.bash_aliases" ]; then
   source "${HOME}/.bash_aliases"
 fi

# Environment variables
HISTSIZE=500000
HISTFILESIZE=5000000
EDITOR=nvim
TERM=screen-256color
ANSIBLE_NOCOWS=1
RIPGREP_CONFIG_PATH=~/.config/ripgreprc

export TERM EDITOR HISTSIZE HISTFILESIZE ANSIBLE_NOCOWS

set -o vi

# Search
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Complete SSH hosts
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

#Pass through for Ctrl-S to work in vim
stty -ixon
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Secrets
DO_API_TOKEN=
REDDIT_CLIENTID=
REDDIT_SECRET=
B2_ACCOUNT_ID=
B2_ACCOUNT_KEY=
RESTIC_REPOSITORY=
RESTIC_PASSWORD_FILE=
HETZNER_API_TOKEN=

[[ -f  $HOME/.env ]] && . $HOME/.env
export DO_API_TOKEN REDDIT_CLIENTID REDDIT_SECRET B2_ACCOUNT_ID B2_ACCOUNT_KEY RESTIC_REPOSITORY RESTIC_PASSWORD_FILE HETZNER_API_TOKEN WALLABAG_USERNAME WALLABAG_PASSWORD WALLABAG_CLIENT_ID WALLABAG_CLIENT_SECRET

