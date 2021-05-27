#!/bin/bash

# nvim
if test -f "$HOME/.config/nvim/init.vim"; then
  rm -i "$HOME/.config/nvim/init.vim"
fi
mkdir -p ~/.config/nvim
ln -s $PWD/dotfiles/init.vim ~/.config/nvim/init.vim

# zsh
if test -f "$HOME/.zshrc"; then
  rm -i "$HOME/.zshrc"
fi
ln -s $PWD/dotfiles/.zshrc ~/.zshrc

# tmux
if test -f "$HOME/.tmux.conf"; then
  rm -i "$HOME/.tmux.conf"
fi
ln -s $PWD/dotfiles/.tmux.conf ~/.tmux.conf
