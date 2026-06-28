{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.browsers;
in
{
  options = {
    usrSettings.browsers = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # end of enable option
      firefox = lib.mkOption {
        type = lib.types.bool;
        default = false;
      }; # end of firefox option
      librewolf = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # end of librewolf option

    }; # end of usrSettings.browsers
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs = {
      firefox.enable = cfg.firefox;
      librewolf.enable = cfg.librewolf;
    }; # end of programs

    home.packages = with pkgs; [
      browsh # Browser within a TUI
    ]; # end of home.packages
  }; # end of config
}
