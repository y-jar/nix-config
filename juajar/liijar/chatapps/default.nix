# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: chat apps: discord + halloy packages per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.chatApps;

  # chat app packages, gated per usrset.chatApps toggle
  chatPackages =
    lib.optionals (cfg.enable && cfg.discord.enable) [ pkgs.discord ]
    ++ lib.optionals (cfg.enable && cfg.halloy.enable) [ pkgs.halloy ];
in
{
  config = {
    packages = chatPackages; # end of packages
  }; # end of config
}
