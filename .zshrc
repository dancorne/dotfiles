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
#prompt stuff
autoload -U colors && colors #allow different colours
PROMPT="%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}%~%{$reset_color%}%# "
