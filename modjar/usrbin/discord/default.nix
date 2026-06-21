{
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.discord;
in
{
  options = {
    usrSettings.discord.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    }; # end of usrSettings.discord.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.discord = {
      enable = cfg.enable;
    }; # end of programs.discord
  }; # end of config
}
