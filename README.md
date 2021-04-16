dotfiles
========

Configuration files for bash, zsh, tmux, vim, git etc.

To clone initially:
```
$ echo .dotfiles/ >> ~/.gitignore
$ git clone --bare git@github.com:dancorne/dotfiles $HOME/.dotfiles
$ git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
# Back up or delete any conflicting files
# Any changes can now be handled with the `dotfiles` alias
```
