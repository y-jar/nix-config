{ lib, config, ... }:
let
  cfg = config.sysSettings.server.nixdraw;
in
{
  options = {
    sysSettings.server.nixdraw = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable nixdraw server";
      }; # end of enable
      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Port for nixdraw server";
      }; # end of port
    }; # end of sysSettings.server.nixdraw
  }; # end of options

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.excalidraw = {
       image = "excalidraw/excalidraw:latest"; # repo link
       ports = [ "${toString cfg.port}:80" ]; #
      }; # end of excalidraw
    virtualisation.docker.enable = cfg.enable;
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable [ cfg.port ];
  }; # end of config
}
