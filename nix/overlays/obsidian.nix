# TODO: watch for issues on nixos github and obsidian discourse and remove when fixed
final: prev: {
  obsidian = prev.obsidian.override {
    makeDesktopItem = args: final.makeDesktopItem (args // { startupWMClass = "md.Obsidian"; });
  };
}
