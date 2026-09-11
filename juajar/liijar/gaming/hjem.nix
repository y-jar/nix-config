# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem gaming: prismlauncher + heroic packages per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
# (home-manager hosts keep the mcpelauncher/zenity extras via ./prism.nix)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.gaming;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = {
    packages = shared.packages; # end of packages
  }; # end of config
}
