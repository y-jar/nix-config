{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.fastfetch;
in
{
  options = {
    usrSettings.fastfetch.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  }; # end of options

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.fastfetch ];
    # link dem files!
    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
    xdg.configFile."fastfetch/logos-bin".source = ./logos-bin;
  };
}
