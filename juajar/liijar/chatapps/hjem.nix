# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem chat apps: discord + halloy packages per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
# (home-manager hosts install the same apps via programs.* modules)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.chatApps;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = {
    packages = shared.packages; # end of packages
  }; # end of config
}
