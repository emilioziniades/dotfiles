# dotfiles

These dotfiles use [Nix](https://nixos.org/) to manage system configuration and development environments.

There are three hosts:

- [`hadedah`](https://github.com/emilioziniades/dotfiles/blob/main/nix/hosts/hadedah/README.md), my personal MacOS laptop
- [`kayak`](https://github.com/emilioziniades/dotfiles/blob/main/nix/hosts/kayak/README.md), my work NixOS laptop
- [`oxo`](https://github.com/emilioziniades/dotfiles/blob/main/nix/hosts/oxo/README.md), a NixOS VirtualBox virtual machine for testing

My development workflow revolves around a combination of [WezTerm](https://wezfurlong.org/wezterm/index.html), [Tmux](https://github.com/tmux/tmux) and [Neovim](https://neovim.io/).

## Useful links

- [24-bit-color.sh](https://github.com/alacritty/alacritty/blob/master/scripts/24-bit-color.sh) - useful for testing colours in terminal setup.
- [Profile zsh startup time](https://esham.io/2018/02/zsh-profiling) - helped me figure out that `nvm` delayed my shell startup by 2 seconds.
