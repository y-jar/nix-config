# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: browsers: firefox/librewolf/chromium per-toggle + browsh (mullvad is system-side).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = config.usrset.browsers;

  # mullvad-vpn is a VPN, not a browser: mirror the system toggle instead of
  # leaking its ~300MiB onto every host with browsers enabled.
  mullvadEnabled = osConfig.sysset.server.vpn.mullvad.enable or false;

  # browser packages, gated per usrset.browsers toggle
  browserPackages =
    # firefox policy dropped with home-manager Ctrl+. pops the GTK emoji dialog again, jemoji covers emoji
    lib.optionals (cfg.enable && cfg.firefox) [ pkgs.firefox ]
    ++ lib.optionals (cfg.enable && cfg.librewolf) [ pkgs.librewolf ]
    ++ lib.optionals (cfg.enable && cfg.chromium) [ pkgs.chromium ]
    ++ lib.optionals cfg.enable [
      pkgs.browsh # browser within a TUI
    ]
    ++ lib.optionals mullvadEnabled [
      pkgs.mullvad-vpn # VPN client 300Mib (mirrors sysset.server.vpn.mullvad)
    ];
in
{
  config = {
    packages = browserPackages; # end of packages
  }; # end of config
}
