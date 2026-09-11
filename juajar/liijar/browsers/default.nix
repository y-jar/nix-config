# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: browsers: firefox/librewolf/chromium per-toggle + browsh/mullvad-vpn.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.browsers;

  # browser packages, gated per usrset.browsers toggle
  browserPackages =
    # firefox policy dropped with home-manager Ctrl+. pops the GTK emoji dialog again, jemoji covers emoji
    lib.optionals (cfg.enable && cfg.firefox) [ pkgs.firefox ]
    ++ lib.optionals (cfg.enable && cfg.librewolf) [ pkgs.librewolf ]
    ++ lib.optionals (cfg.enable && cfg.chromium) [ pkgs.chromium ]
    ++ lib.optionals cfg.enable [
      pkgs.browsh # browser within a TUI
      pkgs.mullvad-vpn # VPN client 300Mib
    ];
in
{
  config = {
    packages = browserPackages; # end of packages
  }; # end of config
}
