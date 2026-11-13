# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: art: per-sub-toggle image/3D/astronomy packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.art;

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

  # per-sub-toggle art package buckets
  artPackages =
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

    # [3d]
    ++ lib.optionals (cfg.enable && cfg.threeD.enable) [
      pkgs.blender # 3D modeling/animation
      pkgs.blockbench # 3D model editor (mincraft)
    ]

    # [astronomy] ref: https://github.com/ryan4yin/nix-config
    ++ lib.optionals (cfg.enable && cfg.astronomy.enable) [
      pkgs.stellarium # planetarium
      pkgs.celestia # 3D space simulation
    ]; # end of artPackages
in
{
  config = {
    packages = artPackages; # end of packages
  }; # end of config
}
