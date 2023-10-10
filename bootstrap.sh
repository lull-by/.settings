#!/bin/bash

# Install Oh My Zsh
if [ ! -e "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Absolute path to this script, e.g. /home/user/bin/foo.sh
script_path=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
script_dir_path=$(dirname "$script_path")
settings_path="$script_dir_path/settings"

nvim_target="$HOME/.config/nvim/init.vim"
nvim_source="$settings_path/init.vim"

vim_target="$HOME/.vimrc"
vim_source="$settings_path/.vimrc"

zsh_target="$HOME/.zshrc"
zsh_source="$settings_path/.zshrc"

tmux_target="$HOME/.tmux.conf"
tmux_source="$settings_path/.tmux.conf"

bash_target="$HOME/.bashrc"
bash_source="$settings_path/.bashrc"

aliases_target="$HOME/.aliases.sh"
aliases_source="$settings_path/.aliases.sh"

secret_aliases_target="$HOME/.secret-aliases.sh"
secret_aliases_source="$settings_path/.secret-aliases.sh"

target_paths=($nvim_target $vim_target $zsh_target $tmux_target $zsh_target $tmux_target $bash_target $aliases_target $secret_aliases_target)
source_paths=($nvim_source $vim_source $zsh_source $tmux_source $zsh_source $tmux_source $bash_source $aliases_source $secret_aliases_source)

# Check if the arrays have the same length
if [ ${#source_paths[@]} -ne ${#target_paths[@]} ]; then
  echo "Error: source and target arrays must have the same length."
  exit 1
fi

# Loop through the arrays and create symbolic links
for ((i=0; i<${#source_paths[@]}; i++)); do
  source="${source_paths[i]}"
  target="${target_paths[i]}"


  # Check if the source file exists
  if [ -e "$source" ]; then
    # Check if the target exists already then prompt user to delete it
    if [ -e "$target" ]; then
      rm -i $target
    fi

    # Verify that the files parent directories have been created
    mkdir -p $(dirname "$target")

    ln -sf "$source" "$target"
    echo "linked '$target' to '$source'"

  else
    echo "Error: Source file '$source' does not exist."
    fi
  done

  echo "All settings have been copied."
