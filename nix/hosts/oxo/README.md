# oxo

`oxo` is the name for my virtualbox config, which is useful for experimenting with nixos features.

Download setup script and run it:

```
curl https://raw.githubusercontent.com/emilioziniades/dotfiles/main/nix/hosts/oxo/setup.sh > setup.sh
chmod +x setup.sh
sudo ./setup.sh
```

## TODO

- [ ] copy configuration.nix from the working vm and stick it into this repo
- [ ] figure out how to use disko, and replace setup.sh with declarative disko config
- [ ] do the install from scratch using disko-install and the code in this repo
