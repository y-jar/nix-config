{
  config,
  lib,
  ...
}:
let
  cfg = config.sysSettings.gaming.prism;
in
{
  options = {
    sysSettings.gaming.prism = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables gaming";
    }; # end of sysSettings.gaming.prism
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.prismlauncher = {
      enable = true;
    }; # end of programs.prismlauncher
  }; # end of config
}
