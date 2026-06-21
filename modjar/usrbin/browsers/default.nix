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
    usrSettings.browsers.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      firefox.enable = true;
      librewolf.enable = true;
    }; # end of programs

    home.packages = with pkgs; [
      browsh # Browser within a TUI
    ]; # end of home.packages
  }; # end of config
}
