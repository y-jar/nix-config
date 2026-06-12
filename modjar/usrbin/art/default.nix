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
    programs = {
      krita = {
        enable = true;
      };
      halftone = {
        enable = true;
      };
      coulr = {
        enable = true;
      };
      blender = {
        enable = true;
      };
    }; # end of programs

    # bulk art appstream
    home.packages = with pkgs; [
      upscayl # Free and Open Source AI Image Upscaler
      converseen # Batch image converter and resizer
      fontforge # Font editor
      digikam # Photo management application
    ];
  }; # end of config
}
