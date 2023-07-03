# dotfiles

**NOTE: I am in the process of migrating all my dotfiles over to nix.**

## MacOS nix-darwin setup

Install nix using the determinate systems installer. Install nix-darwin. Bootstrap nix-darwin flake. From then on, configuration can be updated by runing `darwin-rebuild switch --flake ~/dotfiles`, which I have aliased to simply `switch`.

```
git clone https://github.com/emilioziniades/dotfiles && cd dotfiles
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
nix build ~/dotfiles\#darwinConfigurations.Emilios-MacBook-Pro.system
./result/sw/bin/darwin-rebuild switch --flake ~/.config/darwin

```

# Ubuntu/Pop_OS!/NixOS setup

_TODO_
