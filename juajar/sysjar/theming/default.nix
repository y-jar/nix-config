# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: system-side theming gate + dconf enforcement.
# -=-=-=-=-=-=-=-=-=-=-=
# The truth lives in the user's `usrset.theming`; hjemkey bridges those facts
# up to `sysset.theming` so system modules (dconf, flatpak) can name the exact
# gruvbox theme without hardcoding an accent/variant. When disabled, nothing
# here forces a theme.
{
  config,
  lib,
  ...
}:
let
  cfg = config.sysset.theming;
in
{
  options.sysset.theming = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "System-side theming gate (bridged from usrset.theming.enable)";
    };
    accent = lib.mkOption {
      type = lib.types.enum [
        "orange"
        "red"
        "yellow"
        "green"
        "teal"
        "purple"
        "pink"
        "grey"
        "default"
      ];
      default = "orange";
      description = "Gruvbox accent (bridged from usrset.theming.accent)";
    };
    variant = lib.mkOption {
      type = lib.types.enum [
        "dark"
        "light"
      ];
      default = "dark";
      description = "Gruvbox variant (bridged from usrset.theming.variant)";
    };
    gtkThemeName = lib.mkOption {
      type = lib.types.str;
      default = "Gruvbox-Orange-Dark";
      description = "Exact GTK theme dir name (bridged from usrset.theming.gtkThemeName)";
    };
    iconThemeName = lib.mkOption {
      type = lib.types.str;
      default = "Gruvbox-Plus-Dark";
      description = "Exact icon theme dir name (bridged from usrset.theming.iconThemeName)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Force gruvbox for GSettings consumers (libhandy -> GNOME Boxes, portals,
    # GNOME apps). The stale home-manager `user-db` wins over a plain system
    # default, so lock the keys to enforce our values.
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          gtk-theme = cfg.gtkThemeName;
          icon-theme = cfg.iconThemeName;
          cursor-theme = "jcsr";
          color-scheme = "prefer-dark";
        };
        locks = [
          "/org/gnome/desktop/interface/gtk-theme"
          "/org/gnome/desktop/interface/icon-theme"
          "/org/gnome/desktop/interface/cursor-theme"
          "/org/gnome/desktop/interface/color-scheme"
        ];
      }
    ];
  };
}
