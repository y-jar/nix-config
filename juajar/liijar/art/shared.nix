# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Art shared data: per-sub-toggle image/3D/astronomy packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages =
    # [image processing]
    lib.optionals (cfg.enable && cfg.imageTools) (
      with pkgs;
      [
        drawio # Desktop version of draw.io for creating diagrams
        upscayl # AI image upscaler
        converseen # batch image converter/resizer
        fontforge # font editor
        digikam # photo manager
        coulr # color picker
        halftone # halftone effect generator
        krita # digital painting
        gimp # image manipulation
        inkscape # vector graphics
        mypaint # digital painting
        drawpile # collaborative drawing
      ]
    )

    # [3d]
    ++ lib.optionals (cfg.enable && cfg.threeD) (
      with pkgs;
      [
        blender # 3D modeling/animation
        blockbench # 3D model editor (mincraft)
      ]
    )

    # [astronomy] ref: https://github.com/ryan4yin/nix-config
    ++ lib.optionals (cfg.enable && cfg.astronomy) (
      with pkgs;
      [
        stellarium # planetarium
        celestia # 3D space simulation
      ]
    ); # end of packages
}
