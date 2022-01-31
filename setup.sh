#!/bin/bash
###############
# Creates symlinks in home directory to the dotfiles in this folder
###############

#Variables

dir=~/dotfiles
olddir=~/dotfiles_old
files="zshrc zshenv zprofile"

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# symlink nvim file into ~/.config
<<<<<<< HEAD
echo "Creating symlink to ~/.config/nvim"
=======
>>>>>>> f751c2e19fd5633791f0474724e1f247bae595e2
ln -s $dir/nvim ~/.config/nvim
