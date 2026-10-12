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
  config,
  lib,
  pkgs,
  ...
}:

let
  awwwPackages = [ pkgs.awww ]; # animated wallpaper daemon for Wayland

  awwwSessionVariables = {
    AWWW_TRANSITION = "grow"; # pick a transition effect at random each change
    AWWW_TRANSITION_DURATION = "1"; # seconds, per awww img man page
    AWWW_TRANSITION_STEP = "90"; # how fast the transition approaches the new image
  }; # end of awwwSessionVariables
in
{
  config = lib.mkIf config.usrset.system.hasDesktop {
    packages = awwwPackages;

    environment.sessionVariables = awwwSessionVariables; # end of sessionVariables
  }; # end of config
}
