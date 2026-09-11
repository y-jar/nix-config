# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Ranger terminal file manager.
# -=-=-=-=-=-=-=-=-=-=-=
# The ranger package lives in ./shared.nix (hjem side); the home-manager
# side installs it via programs.ranger.
{
  config,
  lib,
  ...
}:
let
  cfg = config.usrset.ranger;
in
{
  config = lib.mkIf cfg.enable {
    programs.ranger = {
      enable = true;
    }; # end of programs.ranger
  }; # end of config
}
