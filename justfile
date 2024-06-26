update: update-nix-flake update-neovim-plugins

update-nix-flake:
    nix flake update --commit-lock-file

update-neovim-plugins:
    nvim --headless "+Lazy! sync" +qa
    git diff --quiet nvim/lazy-lock.json || git commit -m "nvim: update plugins" nvim/lazy-lock.json
