# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem browsers: firefox/librewolf/chromium packages per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
# (home-manager hosts install the same browsers via programs.* wrappers)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.browsers;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = {
    packages = shared.packages; # end of packages
  }; # end of config
}
