set ignore-comments := true

alias u := update
alias sn := switch-nixos
alias shm := switch-home-manager
alias sd := switch-darwin

default:
    @just --list

update: update-nix-flake update-neovim-plugins

update-nix-flake:
    nix flake update --commit-lock-file

update-neovim-plugins:
    nvim --headless "+lua vim.pack.update()" +qa
    # TODO: commit this when lockfile

switch-nixos:
    sudo --preserve-env nixos-rebuild switch --flake ~/dotfiles

switch-home-manager:
    home-manager switch --flake ~/dotfiles

switch-darwin:
    sudo darwin-rebuild switch --flake ~/dotfiles

# For some reason you need to do both, as root and your user can both hold separate gc roots
tidy:
    nix-collect-garbage --delete-old
    sudo nix-collect-garbage --delete-old

# For testing nvim config changes
nvim-debug file=".":
    nvim --cmd "set rtp^=~/dotfiles/nvim" -u ~/dotfiles/nvim/init.lua {{ file }}
