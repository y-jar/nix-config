{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.ai;
in
{
  options = {
    usrSettings.ai.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lmstudio # for ai
    ]; # end of home.packages
  };
}
