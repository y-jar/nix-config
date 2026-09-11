# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Discord client (home-level enable).
# -=-=-=-=-=-=-=-=-=-=-=
# The discord/halloy packages per-toggle live in ./shared.nix (hjem side);
# the home-manager side installs the same apps via the programs.* modules.
{
  config,
  lib,
  ...
}:
let
  cfg = config.usrset.chatApps;
in
{

  config = lib.mkIf cfg.enable {
    programs.discord = {
      enable = cfg.discord.enable;
    }; # end of programs.discord
    programs.halloy = {
      enable = cfg.halloy.enable;
    }; # end of programs.halloy
  }; # end of config
}
