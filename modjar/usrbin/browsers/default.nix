# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Browsers: firefox/librewolf (user-level home config).
# -=-=-=-=-=-=-=-=-=-=-=
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
      chromium = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # end of chromium option
      default = lib.mkOption {
        type = lib.types.str;
        default = "firefox";
        description = "Preferred browser (command name): used for the WM Super+B/Mod+B keybind and as the default mime browser.";
      }; # end of default option
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
      chromium.enable = cfg.chromium;
    }; # end of programs

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # [browser defaults] follow the preferred browser (usrSettings.browsers.default)
        "text/html" = "${cfg.default}.desktop";
        "x-scheme-handler/http" = "${cfg.default}.desktop";
        "x-scheme-handler/https" = "${cfg.default}.desktop";
        "x-scheme-handler/about" = "${cfg.default}.desktop";
        "x-scheme-handler/unknown" = "${cfg.default}.desktop";
      }; # end of default application
    }; # end of mime apps

    home.packages = with pkgs; [
      browsh # Browser within a TUI
      mullvad-vpn # VPN client 300Mib
    ]; # end of home.packages
  }; # end of config
}
