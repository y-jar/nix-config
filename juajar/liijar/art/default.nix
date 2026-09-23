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

  # per-sub-toggle art package buckets
  artPackages =
    # [image processing]
    lib.optionals (cfg.enable && cfg.imageTools) [
      pkgs.drawio # Desktop version of draw.io for creating diagrams
      pkgs.upscayl # AI image upscaler
      pkgs.converseen # batch image converter/resizer
      pkgs.fontforge # font editor
      pkgs.digikam # photo manager
      pkgs.coulr # color picker
      pkgs.halftone # halftone effect generator
      pkgs.krita # digital painting
      pkgs.gimp # image manipulation
      pkgs.inkscape # vector graphics
      pkgs.mypaint # digital painting
      pkgs.drawpile # collaborative drawing
    ]

    # [3d]
    ++ lib.optionals (cfg.enable && cfg.threeD) [
      pkgs.blender # 3D modeling/animation
      pkgs.blockbench # 3D model editor (mincraft)
    ]

    # [astronomy] ref: https://github.com/ryan4yin/nix-config
    ++ lib.optionals (cfg.enable && cfg.astronomy) [
      pkgs.stellarium # planetarium
      pkgs.celestia # 3D space simulation
    ]; # end of artPackages
in
{
  config = {
    packages = artPackages; # end of packages
  }; # end of config
}
