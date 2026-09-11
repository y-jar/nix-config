# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Desktop tweaks: ddcutil + wayland session vars (desktop hosts only).
# -=-=-=-=-=-=-=-=-=-=-=
# Gated on the hasDesktop specialArg. Session vars land in hjem's user
# environment (loaded from ~/.profile).
{
  lib,
  pkgs,
  hasDesktop,
  ...
}:

{
  config = lib.mkIf hasDesktop {
    packages = [ pkgs.ddcutil ]; # desktop monitor brightness via DDC/CI (shelljar BrightnessService)

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # enable native Wayland support for most Electron apps
      MOZ_ENABLE_WAYLAND = "1"; # for firefox to run on wayland
      MOZ_WEBRENDER = "1"; # enable web rendering for firefox on wayland
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
    }; # end of sessionVariables
  }; # end of config
}
