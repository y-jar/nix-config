# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: awww shared data (package + transition env vars).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/awww/shared.nix] =-=-=
# The awww package + the centralized transition env vars shared by both
# backends. Transition config is centralized here via env vars
# (AWWW_TRANSITION=random), so scripts/shelljar pass no CLI flags for it.
# Both backends gate on the hasDesktop specialArg (see hm.nix / hjem.nix).
# =-=-=[end liijar/awww/shared.nix] =-=-=
{ pkgs, ... }:

{
  packages = [ pkgs.awww ]; # animated wallpaper daemon for Wayland

  sessionVariables = {
    AWWW_TRANSITION = "random"; # pick a transition effect at random each change
    AWWW_TRANSITION_DURATION = "1"; # seconds, per awww img man page
    AWWW_TRANSITION_STEP = "90"; # how fast the transition approaches the new image
  }; # end of sessionVariables
}
