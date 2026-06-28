{ ... }:

{
  config = {
    home.sessionVariables = {
      "NIXOS_OZONE_WL" = "1"; # enable native Wayland support for most Electron apps
      "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
      "MOZ_WEBRENDER" = "1"; # enable web rendering for firefox on wayland
      # enable native Wayland support for most Electron apps
      "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
      # misc
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
      "SDL_VIDEODRIVER" = "wayland";
      "GDK_BACKEND" = "wayland";
      "XDG_SESSION_TYPE" = "wayland";
    }; # end of sessionVariables
  }; # end of config
}
