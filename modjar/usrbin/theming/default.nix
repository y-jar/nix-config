{ lib, ... }: {
  imports = [
    ./gtk.nix # GTK theme
    ./qt.nix # Qt theme
  ];
  options = {
    theming.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable theming";
    };
  };
}
