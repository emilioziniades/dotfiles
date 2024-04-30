{dotfiles-secrets, ...}: {
  age.secrets.vpn-config.file = "${dotfiles-secrets}/secrets/vpn-config.age";
}
