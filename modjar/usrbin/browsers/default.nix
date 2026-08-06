{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.browsers;
in
{
  options = {
    usrSettings.browsers = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable browsers (~500MiB, librewolf + firefox)";
      }; # end of enable option
      firefox = lib.mkOption {
        type = lib.types.bool;
        default = false;
      }; # end of firefox option
      librewolf = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # end of librewolf option

    }; # end of usrSettings.browsers
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs = {
      firefox = {
        enable = cfg.firefox;
        # Firefox 150+ pops the native GTK emoji dialog on Ctrl+. which clashes
        # with mozc's Ctrl+. = full katakana; jemoji on Super+Alt+Space covers
        # emoji instead.
        policies.Preferences."widget.gtk.native-emoji-dialog" = false;
      };
      librewolf.enable = cfg.librewolf;
    }; # end of programs

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # [browser defaults]
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      }; # end of default application
    }; # end of mime apps

    home.packages = with pkgs; [
      browsh # Browser within a TUI
    ]; # end of home.packages
  }; # end of config
}
