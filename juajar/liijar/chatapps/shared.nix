# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Chat apps shared data: discord + halloy packages per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
# hjem hosts install them as plain packages; home-manager hosts get the
# same apps via programs.discord/programs.halloy in hm.nix.
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages =
    lib.optionals (cfg.enable && cfg.discord.enable) [ pkgs.discord ]
    ++ lib.optionals (cfg.enable && cfg.halloy.enable) [ pkgs.halloy ]; # end of packages
}
