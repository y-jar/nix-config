# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: creation: per-sub-toggle image/video/3D/astronomy packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.creation;

  # Krita 6.0.2.1 (Qt 6.11.2) segfaults in
  # QGuiApplicationPrivate::processTabletLeaveProximityEvent when a pen barrel
  # button is pressed (KDE bugs 503464/524685). XWayland avoids Qt's native
  # Wayland tablet path; the compositor mapping still sends the pen to its display.
  krita =
    if cfg.kritaXWayland.enable then
      pkgs.symlinkJoin {
        name = "krita-xwayland";
        paths = [ pkgs.krita ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/krita --set QT_QPA_PLATFORM xcb
        '';
      }
    else
      pkgs.krita;

  # per-sub-toggle creation package buckets
  creationPackages =
    # [image processing]
    lib.optionals (cfg.enable && cfg.imageTools.enable) [
      pkgs.drawio # Desktop version of draw.io for creating diagrams
      pkgs.upscayl # AI image upscaler
      pkgs.converseen # batch image converter/resizer
      pkgs.fontforge # font editor
      pkgs.digikam # photo manager
      pkgs.coulr # color picker
      pkgs.halftone # halftone effect generator
      krita # digital painting (if i happen to revert, just prepend pkgs.)
      pkgs.gimp # image manipulation
      pkgs.inkscape # vector graphics
      pkgs.mypaint # digital painting
      pkgs.drawpile # collaborative drawing
    ]

    # [video]
    ++ lib.optionals (cfg.enable && cfg.obs.enable) [
      pkgs.obs-studio
      pkgs.obs-studio-plugins.wlrobs # wlroots screen capture
      pkgs.obs-studio-plugins.obs-backgroundremoval # background replacement
      pkgs.obs-studio-plugins.obs-pipewire-audio-capture # pipewire audio/app capture
      pkgs.obs-studio-plugins.obs-vaapi # AMD hardware acceleration
      pkgs.obs-studio-plugins.obs-gstreamer # gstreamer sources/filters
      pkgs.obs-studio-plugins.obs-vkcapture # vulkan/opengl game capture
    ]
    ++ lib.optionals (cfg.enable && cfg.kdenlive.enable) [
      pkgs.kdePackages.kdenlive # video editor
    ]

    # [3d]
    ++ lib.optionals (cfg.enable && cfg.threeD.enable) [
      pkgs.blender # 3D modeling/animation
      pkgs.blockbench # 3D model editor (mincraft)
    ]

    # [astronomy] ref: https://github.com/ryan4yin/nix-config
    ++ lib.optionals (cfg.enable && cfg.astronomy.enable) [
      pkgs.stellarium # planetarium
      pkgs.celestia # 3D space simulation
    ]; # end of creationPackages
in
{
  config = {
    packages = creationPackages; # end of packages
  }; # end of config
}
