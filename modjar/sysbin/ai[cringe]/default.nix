{ config, lib, pkgs, ... }:

let
  cfg = config.sysSettings.ai;
in
{
  options = {
    sysSettings.ai = {
      enable = lib.mkEnableOption "Enable AI tools (~2GiB, Ollama + models)";
      port = lib.mkOption {
        type = lib.types.port;
        default = 11434;
        description = "Port for the Ollama API";
      };
      webui = {
        enable = lib.mkEnableOption "Open WebUI — browser-based chat interface for Ollama";
        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          description = "Port for the Open WebUI web interface";
        }; # end of webui port option
      }; # end of webui options
    }; # end of ai options
  }; # end of options

  config = lib.mkMerge [
    # Ollama (always when ai is enabled)
    (lib.mkIf cfg.enable {
      services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm; # Swap to ollama-cuda for Nvidia, or ollama for CPU only
        host = "0.0.0.0"; # The host address which the ollama server HTTP interface listens to.
        port = cfg.port;
        syncModels = false; # set true + loadModels to auto-manage models (deletes undeclared ones)
        # [models] this is causing issues.. just run `pull-models`
        # loadModels = [
        #   "qwen3.5:9b"
        #   "qwen3.5:9b-mlx"
        #   "frob/ministral-3:14b"
        #   "frob/ministral-3:3b"
        #   "mistral:7b"
        #   "gemma4:latest"
        # ];
        # troubleshooting: if models don't pull after rebuild, run:
        #   sudo systemctl restart ollama-model-loader.service
      }; # end of ollama config
      networking.firewall.allowedTCPPorts = [ cfg.port ];
    }) # end of ollama config

    # Open WebUI (optional, uses host networking to reach Ollama on localhost)
    (lib.mkIf cfg.webui.enable {
      virtualisation.docker.enable = true;
      virtualisation.oci-containers.containers.open-webui = {
        image = "ghcr.io/open-webui/open-webui:main";
        networks = [ "host" ];
        volumes = [ "open-webui:/app/backend/data" ];
        environment = {
          WEBUI_AUTH = "true";
        };
      };
      networking.firewall.allowedTCPPorts = [ cfg.webui.port ];
    }) # end of webui config
  ]; # end of config
}
