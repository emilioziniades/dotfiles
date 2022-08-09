#!/bin/bash

function setup_ubuntu() {
    sudo apt upgrade && sudo apt update

    git clone https://github.com/emilioziniades/dotfiles

    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt update

    sudo apt install -y neovim

    sudo apt install -y zsh
    chsh $(which zsh)

}

function setup_macos() {
    touch ~/.hushlogin
}

function setup() {
    dotdir=~/dotfiles
    olddotdir=~/dotfiles_old
    files="zshrc zshenv zprofile tmux.conf"

    mkdir -p $olddotdir
    cd $dotdir

    for file in $files; do
        if [[ -f ~/.$file ]] then
            mv ~/.$file $olddotdir
        fi
        ln -s $dotdir/$file ~/.$file
    done

    mkdir -p ~/.config
    ln -s $dotdir/nvim ~/.config/nvim



}

if test -f /etc/os-release then
    os_type=$(grep -oP '^NAME="\K\w*' /etc/os-release)
else
    os_type="MacOS"
fi

if $os_type = "Ubuntu" then
    setup_ubuntu
else
    setup_macos
fi
setup
