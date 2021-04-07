#!/bin/bash

mkdir -p ~/.config/nvim
ln -s $PWD/dotfiles/init.vim ~/.config/nvim/init.vim
ln -s $PWD/dotfiles/.vimrc ~/.vimrc
ln -s $PWD/dotfiles/.zshrc ~/.zshrc
