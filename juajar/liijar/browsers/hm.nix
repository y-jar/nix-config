# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Browsers: firefox/librewolf/chromium (user-level home config).
# -=-=-=-=-=-=-=-=-=-=-=
# The browser packages per-toggle live in ./shared.nix (hjem side); the
# home-manager side installs them via the programs.* wrappers below, which
# bake in policies so no raw browser packages are added to home.packages.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.browsers;
in
{

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
        # [browser defaults] follow the preferred browser (usrset.browsers.default)
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
