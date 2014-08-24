dotfiles
========

Configuration files for bash, zsh, tmux, vim, git.


The setup.sh should symlink them across to the appropriate place in ~ and backup any current files being replaced. NB As gitconfig gets copied across, setup.sh will also ask for git username and email address to reset them as global settings. Obviously this can be done one-by-one for individual configs, I'm too lazy to make it overly interactive (for now at least).
