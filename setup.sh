#!/bin/bash

function setup_ubuntu() {
    sudo apt upgrade && sudo apt update

    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt update

    sudo apt install -y neovim

    sudo apt install -y zsh
    chsh $(which zsh)

}

function setup_macos() {

    touch ~/.hushlogin

    if ! command -v brew &> /dev/null
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        xargs brew install < ./brew/brew_casks.txt
        xargs brew install < ./brew/brew_packages.txt
        brew tap homebrew/cask-fonts
        brew install font-meslo-lg-nerd-font
    fi
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

    if [[ ! -d ~/.tmux/plugins/tpm ]] 
    then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ~/.tmux/plugins/tpm/scripts/update_plugin.sh
    fi

}

if [[ -f /etc/os-release ]] 
then
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
reset
