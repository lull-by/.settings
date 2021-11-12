#!/bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

NVIMTARGET="$HOME/.config/nvim/init.vim"
NVIMSOURCE="$SCRIPTPATH/dotfiles/init.vim"

VIMTARGET="$HOME/.vimrc"
VIMSOURCE="$SCRIPTPATH/dotfiles/.vimrc"

ZSHTARGET="$HOME/.zshrc"
ZSHSOURCE="$SCRIPTPATH/dotfiles/.zshrc"

TMUXTARGET="$HOME/.tmux.conf"
TMUXSOURCE="$SCRIPTPATH/dotfiles/.tmux.conf"

# nvim
# check if config file exists
if [ -e $NVIMTARGET ]; then
  rm -i $NVIMTARGET
else
  mkdir -p ~/.config/nvim
fi
ln -sf $NVIMSOURCE $NVIMTARGET

# vim
if [ -e $VIMTARGET ]; then
  rm -i $VIMTARGET
fi
ln -sf $VIMSOURCE $VIMTARGET

# zsh
if [ -e $ZSHTARGET ]; then
  rm -i $ZSHTARGET
fi
ln -sf $ZSHSOURCE $ZSHTARGET

# tmux
if [ -e $TMUXTARGET ]; then
  rm -i $TMUXTARGET
fi
ln -sf $TMUXSOURCE $TMUXTARGET
