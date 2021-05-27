#!/bin/bash

# nvim
if test -f "$HOME/.config/nvim/init.vim"; then
  rm -i "$HOME/.config/nvim/init.vim"
fi
mkdir -p ~/.config/nvim
ln -s $PWD/dotfiles/init.vim "$HOME/.config/nvim/init.vim"

# vim
if test -f ~/.vimrc; then
  rm -i "$HOME/.vimrc"
fi
ln -s $PWD/dotfiles/.vimrc "$HOME/.vimrc"

# zsh
if test -f "$HOME/.zshrc"; then
  rm -i "$HOME/.zshrc"
fi
ln -s $PWD/dotfiles/.zshrc "$HOME/.zshrc"

# tmux
if test -f "$HOME/.tmux.conf"; then
  rm -i "$HOME/.tmux.conf"
fi
ln -s $PWD/dotfiles/.tmux.conf $HOME/.tmux.conf
