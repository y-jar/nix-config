# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Theme options: gtk/qt flavor, accent, cursor size.
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, ... }: {
  imports = [
    ./gtk.nix # GTK theme
    ./qt.nix # Qt theme
  ];
  options.usrSettings = {
    theming.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable theming";
    };
    theming.flavor = lib.mkOption {
      type = lib.types.enum [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
      default = "mocha";
      description = "Catppuccin flavor, shared between gtk.nix and qt.nix";
    };
    theming.accent = lib.mkOption {
      type = lib.types.str;
      default = "blue";
      description = "Catppuccin accent color, shared between gtk.nix and qt.nix";
    };
    theming.cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 36;
      description = "Cursor size in pixels (GTK/pointer)";
    };
  };
}
