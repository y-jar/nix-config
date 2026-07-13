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
    ./aiScriptsjar # ai related scripts
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

    services.ollama = {
      enable = true;
      acceleration = "rocm"; # Swap to "cuda" if using an Nvidia GPU, or leave this line out for CPU only
    }; # end of services.ollama
  }; # end of config
}
