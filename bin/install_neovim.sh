#!/bin/bash
set -e
mkdir -p ~/.local/bin/
wget -O ~/.local/bin/nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x ~/.local/bin/nvim
