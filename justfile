update: update-flake update-neovim

update-flake:
    nix flake update --commit-lock-file

update-neovim:
    nvim --headless "+Lazy! sync" +qa
    git add nvim/lazy-lock.json
    git commit -m "nvim: update plugins"

