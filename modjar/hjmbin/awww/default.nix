# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: awww install + transition env vars.
# -=-=-=-=-=-=-=-=-=-=-=
# Mirror of modjar/usrbin/awww/ for hjem hosts. Gated on a Wayland compositor
# (niri/hyprland); transition type centralized via AWWW_TRANSITION env.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.hjmSettings;
in
{
  config = lib.mkIf (hjm.niri.enable || hjm.hyprland.enable) {
    packages = [ pkgs.awww ]; # animated wallpaper daemon for Wayland

    environment.sessionVariables = {
      AWWW_TRANSITION = "random"; # pick a transition effect at random each change
      AWWW_TRANSITION_DURATION = "1"; # seconds, per awww img man page
      AWWW_TRANSITION_STEP = "90"; # how fast the transition approaches the new image
    }; # end of sessionVariables
  }; # end of config
}