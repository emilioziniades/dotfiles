set ignore-comments := true

alias u := update
alias sn := switch-nixos
alias shm := switch-home-manager
alias sd := switch-darwin

update: update-nix-flake update-neovim-plugins

update-nix-flake:
    nix flake update --commit-lock-file

update-neovim-plugins:
    nvim --headless "+Lazy! sync" +qa
    git diff --quiet nvim/lazy-lock.json || git commit -m "nvim: update plugins" nvim/lazy-lock.json

switch-nixos:
    sudo --preserve-env nixos-rebuild switch --flake ~/dotfiles

switch-home-manager:
    home-manager switch --flake ~/dotfiles

switch-darwin:
    darwin-rebuild switch --flake ~/dotfiles

# For some reason you need to do both, as root and your user can both hold separate gc roots
tidy:
    nix-collect-garbage --delete-old
    sudo nix-collect-garbage --delete-old
