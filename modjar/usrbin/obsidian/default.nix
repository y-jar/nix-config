{
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.obsidian;
in
{
  options = {
    usrSettings.obsidian = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.obsidian = {
      enable = true;
    };
  };
}
