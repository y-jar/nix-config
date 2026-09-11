# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: awww (animated wallpaper daemon) install + transition config.
# -=-=-=-=-=-=-=-=-=-=-=
# Gated on a desktop/window-manager being enabled (the hasDesktop
# specialArg), so nothing is installed when no WM is picked. Transition
# config is centralized in the env vars below (AWWW_TRANSITION=random), so
# scripts/shelljar pass no CLI flags for it; the env vars land in the user
# environment -> .profile via loadEnv.
{
  lib,
  pkgs,
  hasDesktop,
  ...
}:

let
  awwwPackages = [ pkgs.awww ]; # animated wallpaper daemon for Wayland

  awwwSessionVariables = {
    AWWW_TRANSITION = "random"; # pick a transition effect at random each change
    AWWW_TRANSITION_DURATION = "1"; # seconds, per awww img man page
    AWWW_TRANSITION_STEP = "90"; # how fast the transition approaches the new image
  }; # end of awwwSessionVariables
in
{
  config = lib.mkIf hasDesktop {
    packages = awwwPackages;

    environment.sessionVariables = awwwSessionVariables; # end of sessionVariables
  }; # end of config
}
