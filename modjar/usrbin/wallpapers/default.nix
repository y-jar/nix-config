{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.usrSettings.addMyWalls;
in
{
  options = {
    usrSettings.addMyWalls = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable theming";
      }; # end of theming.enable
    }; # end of usrSettings.addMyWalls
  }; # end of options

  config = lib.mkIf cfg.enable {
    home.file."pic-jar/wall-jar".source = inputs.wall-jar; # my wallpaper entry
  }; # end of config
}
