#!/bin/bash
###############
# Creates symlinks in home directory to the dotfiles in this folder
###############

#Variables

dir=~/dotfiles
olddir=~/dotfiles_old
files="zshrc zshenv zprofile tmux.conf"

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
echo "Moving any existing dotfiles from ~ to $olddir"
for file in $files; do
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# symlink nvim file into ~/.config
echo "Creating symlink to ~/.config/nvim"
ln -s $dir/nvim ~/.config/nvim

# prevent last login message on MacOS
touch ~/.hushlogin


