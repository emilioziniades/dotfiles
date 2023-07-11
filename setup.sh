#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

setup_debian() {
    sudo apt update && sudo apt upgrade -y

    sudo apt install -y \
        build-essential \
        zsh \
        fd-find \
        ripgrep \
        zip \
        tmux \
        fzf \
        jq \
        python3-pip \
        python3.10-venv \
        tree

    LOCALBIN=~/.local/bin
    mkdir -p $LOCALBIN
    if [ ! -L $LOCALBIN/fd ]; then
        ln -s $(which fdfind) $LOCALBIN/fd
    fi


    $SCRIPT_DIR/bin/install_neovim.sh

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | zsh

    chsh -s $(which zsh)
}

setup_macos() {
    if ! command -v brew &> /dev/null
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        xargs brew install < ./brew/brew_casks.txt
        xargs brew install < ./brew/brew_packages.txt
        brew tap homebrew/cask-fonts
        brew install font-meslo-lg-nerd-font
    fi
}

setup() {
    touch ~/.hushlogin
    
    dotdir=~/dotfiles
    olddotdir=~/dotfiles_old

    files="zshrc"
    for file in $files; do
        if [[ -f ~/.$file && ! -L ~/.$file ]]
        then
            mkdir -p $olddotdir
            mv ~/.$file $olddotdir
            ln -s $dotdir/$file ~/.$file
        fi
    done

    config_folders="nvim tmux alacritty regolith2"
    mkdir -p ~/.config
    for config_folder in $config_folders; do
        if [[ ! -L ~/.config/$config_folder ]]
        then
            ln -s $dotdir/$config_folder ~/.config/$config_folder
        fi
    done

    if [[ ! -d ~/.tmux/plugins/tpm ]] 
    then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ~/.tmux/plugins/tpm/bin/install_plugins
    fi


}

if [[ -f /etc/os-release ]] 
then
    os_type=$(grep -oP '^NAME="\K([^"]*)' /etc/os-release)
else
    os_type="MacOS"
fi

if [[ $os_type == "Ubuntu" || $os_type == "Pop!_OS" ]]
then
    setup_debian
else
    setup_macos
fi
setup
echo "restart the terminal and enjoy!"
