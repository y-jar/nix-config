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
    };
  };
  config = lib.mkIf cfg.enable {
    programs.discord = {
      enable = cfg.enable;
    };
  };
}
