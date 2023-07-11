#!/bin/bash
set -e
sudo add-apt-repository universe
sudo apt install libfuse2
mkdir -p ~/.local/bin/
wget -O ~/.local/bin/nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x ~/.local/bin/nvim
