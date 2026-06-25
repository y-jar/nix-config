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
      upscayl # Free and Open Source AI Image Upscaler
      converseen # Batch image converter and resizer
      fontforge # Font editor
      digikam # Photo management application
      blender # 3D modeling and animation software
      blockbench # 3D model editor [mincraft stuff]
      coulr # Color picker
      halftone # Halftone effect generator
      krita # Digital painting and illustration software
      gimp # GNU Image Manipulation Program
      inkscape # Vector graphics editor
    ]; # end of packages
  }; # end of config
}
