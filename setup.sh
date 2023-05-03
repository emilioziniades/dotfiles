#!/bin/bash

function setup_ubuntu() {
    sudo apt update && sudo apt upgrade -y

    sudo apt install -y \
        build-essential \
        zsh \
        fd-find \
        ripgrep \
        zip \
        tmux \
	fuse \
        jq

    # install neovim from .appimage
    mkdir -p ~/.local/bin/
    wget -O ~/.local/bin/nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    chmod u+x ~/.local/bin/nvim

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | zsh

    chsh -s $(which zsh)
}

function setup_macos() {
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
    touch ~/.hushlogin
    
    dotdir=~/dotfiles
    olddotdir=~/dotfiles_old
    files="zshrc tmux.conf alacritty.yml"
    mkdir -p $olddotdir
    cd $dotdir
    for file in $files; do
        if [[ -f ~/.$file ]] 
        then
            mv ~/.$file $olddotdir
        fi
        ln -s $dotdir/$file ~/.$file
    done

    mkdir -p ~/.config
    if [[ ! -L ~/.config/nvim ]]
    then
        ln -s $dotdir/nvim ~/.config/nvim
    fi

    if [[ ! -d ~/.tmux/plugins/tpm ]] 
    then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ~/.tmux/plugins/tpm/bin/install_plugins
        ~/.tmux/plugins/tpm/bin/update_plugins all
    fi

}

if [[ -f /etc/os-release ]] 
then
    os_type=$(grep -oP '^NAME="\K\w*' /etc/os-release)
else
    os_type="MacOS"
fi

if [[ $os_type == "Ubuntu" ]] 
then
    setup_ubuntu
else
    setup_macos
fi
setup
echo "restart the terminal and enjoy!"
