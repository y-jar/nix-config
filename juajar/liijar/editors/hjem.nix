# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem editors: vscodium/zed/obsidian/helix packages per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
# (home-manager hosts install the same editors via programs.* in hm.nix;
# hjem hosts get nvf via the system-level bridge sysset.nvf instead)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.editors;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = {
    packages = shared.packages; # end of packages
  }; # end of config
}
