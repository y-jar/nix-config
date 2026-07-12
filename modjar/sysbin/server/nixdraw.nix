{ inputs, lib, config, ... }:
let
  cfg = config.sysSettings.server.nixdraw;
in
{
  imports = [
    inputs.nixdraw
  ]; # end of imports

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

  config = {
    services.excalidraw = {
      enable = cfg.enable;
      port = cfg.port;
    }; # end of excalidraw
  }; # end of config
}
