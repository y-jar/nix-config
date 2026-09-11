# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: KeePassXC password manager.
# -=-=-=-=-=-=-=-=-=-=-=
# The keepassxc package lives in ./shared.nix (hjem side); the
# home-manager side installs it via programs.keepassxc.
{
  config,
  lib,
  ...
}:
let
  cfg = config.usrset.keepass;
in
{

  config = lib.mkIf cfg.enable {
    programs.keepassxc = {
      enable = true;
    };
  }; # end of config
}
