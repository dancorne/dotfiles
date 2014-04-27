#!/bin/bash

#Get dotfiles directory, in case different to ~/dotfiles
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d ~/.vim/bundle/vundle ]; then
    echo "It doesn't look like vundle is installed at ~/.vim/bundle/vundle, installing now..."
    git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/vundle
else
    echo "Looks like vundle is installed at ~/.vim/bundle/vundle, great!"
fi

if [ -e ~/.bashrc ]; then
    echo "~/.bashrc detected. Backing up..."
    mv ~/.bashrc ~/.bashrc.backup
fi

if [ -e ~/.vimrc ]; then
    echo "~/.vimrc detected. Backing up..."
    mv ~/.vimrc ~/.vimrc.backup
fi

if [ -e ~/.bash_aliases ]; then
    echo "~/.bash_aliases detected, stealing aliases and backing up..."
    mv ~/.bash_aliases ~/.bash_aliases.backup
    cat ~/.bash_aliases.backup >> $DIR/bash_aliases
fi

ln -s $DIR/bashrc ~/.bashrc
ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/bash_aliases ~/.bash_aliases

echo "rc files linked, sanity check with diff..."
diff ~/.bashrc $DIR/bashrc
diff ~/.vimrc $DIR/vimrc
diff ~/.bash_aliases $DIR/bash_aliases

exit 0
