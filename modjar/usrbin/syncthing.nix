{
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.syncthing;
in
{
  options.usrSettings.syncthing = {
    enable = lib.mkEnableOption {
      description = "Enable Syncthing file sync (web UI at localhost:8384)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
