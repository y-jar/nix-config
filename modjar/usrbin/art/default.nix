# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Creative suite: Blender + Krita + GIMP + Inkscape.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.art;
in
{
  options = {
    usrSettings.art = {
      enable = lib.mkEnableOption "art tools (master toggle)";
      imageTools = lib.mkEnableOption "2D/painting tools (krita, gimp, inkscape, ...)";
      threeD = lib.mkEnableOption "3D tools (blender, blockbench)";
      astronomy = lib.mkEnableOption "astronomy apps (stellarium, celestia)";
    };
  };

  config = lib.mkIf cfg.enable {
    # [bulk art appstream]
    home.packages = lib.mkMerge [
      # [image processing]
      (lib.mkIf cfg.imageTools (
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
      ))

      # [3d]
      (lib.mkIf cfg.threeD (
        with pkgs;
        [
          blender # 3D modeling/animation
          blockbench # 3D model editor (mincraft)
        ]
      ))

      # [astronomy] ref: https://github.com/ryan4yin/nix-config
      (lib.mkIf cfg.astronomy (
        with pkgs;
        [
          stellarium # planetarium
          celestia # 3D space simulation
        ]
      ))
    ]; # end of home.packages
  }; # end of config
}
