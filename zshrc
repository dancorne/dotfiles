if [ "$TMUX" = "" ]; then tmux; fi
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
setopt autocd extendedglob
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# completion
autoload -U compinit
compinit 
#reverse-interactive-search
bindkey '^R' history-incremental-search-backward
