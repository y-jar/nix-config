# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: awww (animated wallpaper daemon) install + transition config (home-manager side).
# -=-=-=-=-=-=-=-=-=-=-=
# Gated on a desktop/window-manager being enabled (hasDesktop), so nothing is
# installed when no WM is picked. Package + transition env vars live in
# ./shared.nix.
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
    home.packages = shared.packages;

    home.sessionVariables = shared.sessionVariables; # end of sessionVariables
  }; # end of config
}
