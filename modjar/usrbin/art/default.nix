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
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  }; # end of options

  config = lib.mkIf cfg.enable {
    # bulk art appstream
    home.packages = with pkgs; [
      # [image processing]
      upscayl # Free and Open Source AI Image Upscaler
      converseen # Batch image converter and resizer
      fontforge # Font editor
      digikam # Photo management application
      coulr # Color picker
      halftone # Halftone effect generator
      krita # Digital painting and illustration software
      gimp # GNU Image Manipulation Program
      inkscape # Vector graphics editor

      blender # 3D modeling and animation software
      blockbench # 3D model editor [mincraft stuff]

      # [astronomy] ref: https://github.com/ryan4yin/nix-config
      stellarium # See what you can see with your eyes, binoculars or a small telescope.
      celestia # Real-time 3D simulation of space, travel throughout the solar system.
    ]; # end of packages
  }; # end of config
}
