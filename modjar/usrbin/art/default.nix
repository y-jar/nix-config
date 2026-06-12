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
      blender
      coulr
      halftone
      krita
    ];
  }; # end of config
}
