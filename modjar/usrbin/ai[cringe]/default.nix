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
  imports = [
    ./opencode.nix # the config for opencode
  ]; # end of imports
  options = {
    usrSettings.ai.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    }; # end of ai.enable
  }; # end of options
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lmstudio # for ai
    ]; # end of home.packages
  }; # end of config
}
