{
  lib,
  config,
  ...
}:
let
  cfg = config.sysSettings.server.komga;
in
{
  options = {
    sysSettings.server.komga = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Komga firewall port (25600)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 25600 ];
  };
}
