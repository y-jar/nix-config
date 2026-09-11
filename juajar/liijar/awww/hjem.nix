# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: awww (animated wallpaper daemon) install + transition config (hjem side).
# -=-=-=-=-=-=-=-=-=-=-=
# Gated on a desktop/window-manager being enabled (hasDesktop — unified with
# the home-manager backend). Package + transition env vars live in
# ./shared.nix; the env vars land in hjem's user environment -> .profile.
{
  lib,
  pkgs,
  hasDesktop,
  ...
}:

let
  shared = import ./shared.nix { inherit pkgs; };
in
{
  config = lib.mkIf hasDesktop {
    packages = shared.packages;

    environment.sessionVariables = shared.sessionVariables; # end of sessionVariables
  }; # end of config
}
