#!/bin/bash

#Get dotfiles directory, in case different to ~/dotfiles
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d ~/.config/nvim/autoload/plug.vim ]; then
    echo "It doesn't look like plug.vim is installed at ~/.config/nvim/autoload/, installing now..."
    curl --create-dirs -Lo ~/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "Looks like plug.vim is installed at ~/.config/nvim/ great!"
fi

for f in $DIR/{vimrc,bashrc,tmux.conf,zshrc,gitconfig}
do
    name=$(basename $f)
    if [ -e ~/.$name ]; then
        echo "~/.$name detected. Backing up..."
        mv ~/.$name ~/.$name.backup
    fi
    ln -s $f ~/.$name
done

if [ -e ~/.bash_aliases ]; then
    echo "~/.bash_aliases detected, stealing aliases and backing up..."
    mv ~/.bash_aliases ~/.bash_aliases.backup
    cat ~/.bash_aliases.backup >> $DIR/bash_aliases
fi

ln -s $DIR/bash_aliases ~/.bash_aliases

echo "rc files linked, sanity check with diff..."
for f in $DIR/{bashrc,bash_aliases,tmux.conf,zshrc,gitconfig}
do
    name=$(basename $f)
    diff -s ~/.$name $f
done

echo "Setting global username and email address for git..."
echo "What is your name?"
read username
echo "What is your email address?"
read email
git config --global user.name "$username"
git config --global user.email "$email"

exit 0
