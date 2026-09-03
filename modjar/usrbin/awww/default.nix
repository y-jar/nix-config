# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: awww (animated wallpaper daemon) install + transition config.
# -=-=-=-=-=-=-=-=-=-=-=
# Gated on a desktop/window-manager being enabled (hasDesktop), so nothing is
# installed when no WM is picked. Transition config is centralized here via env
# vars (AWWW_TRANSITION=random), so scripts/shelljar pass no CLI flags for it.
{
  config,
  lib,
  pkgs,
  hasDesktop,
  ...
}:

{
  config = lib.mkIf hasDesktop {
    home.packages = [ pkgs.awww ]; # animated wallpaper daemon for Wayland

    home.sessionVariables = {
      AWWW_TRANSITION = "random"; # pick a transition effect at random each change
      AWWW_TRANSITION_DURATION = "1"; # seconds, per awww img man page
      AWWW_TRANSITION_STEP = "90"; # how fast the transition approaches the new image
    }; # end of sessionVariables
  }; # end of config
}