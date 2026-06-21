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
    }; # end of theming.enable
    theming.flavor = lib.mkOption {
      type = lib.types.enum [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
      default = "mocha";
      description = "Catppuccin flavor, shared between gtk.nix and qt.nix";
    }; # end of theming.flavor
    theming.accent = lib.mkOption {
      type = lib.types.str;
      default = "blue";
      description = "Catppuccin accent color, shared between gtk.nix and qt.nix";
    }; # end of theming.accent
  }; # end of options
}
