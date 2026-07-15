{ lib, config, ... }:

let
  cfg = config.sysSettings.server.webjar;
  webroot = ./.;
in
{
  options.sysSettings.server.webjar = {
    enable = lib.mkEnableOption {
      description = "Enable the self-hosted web hub (nginx static page)";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 80;
      description = "Port to serve the web hub on";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true; # Enable recommended gzip settings. Learn more about compression in Gzip format here.
      recommendedOptimisation = true; # Enable recommended optimisation settings.
      recommendedProxySettings = true; # Whether to enable recommended proxy settings if a vhost does not specify the option manually.

      virtualHosts."_" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = cfg.port;
          }
        ]; # End of listen config

        root = "/var/lib/webjar"; # The path of the web root directory.

        # Declarative location config
        locations."/" = {
          tryFiles = "$uri /index.html";
        }; # End of location config
      }; # End of virtualHosts._
    }; # End of nginx config

    system.activationScripts.webjar = ''
      mkdir -p /var/lib/webjar
      cp ${webroot}/index.html ${webroot}/style.css /var/lib/webjar/
    ''; # End of activation script
  }; # End of config
}
