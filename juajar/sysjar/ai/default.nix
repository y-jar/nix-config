# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: AI backend entry: shared options + one file per backend.
# -=-=-=-=-=-=-=-=-=-=-=
#   ./ollama.nix    sysset.ai.ollama.*   (services.ollama)
#   ./llama-cpp.nix sysset.ai.llama.*    (services.llama-cpp)
#   ./models.nix    shared model registry (imported, not a module)
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./ollama.nix
    ./llama-cpp.nix
  ];

  options.sysset.ai = {
    enable = lib.mkEnableOption "Enable AI tools (opencode / llama.cpp / ollama / webui)";
    port = lib.mkOption {
      type = lib.types.port;
      default = 11434;
      description = "Port for the local AI backend API";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address the local AI backend binds. Use 127.0.0.1 to keep it private to this machine";
    };
    webui = {
      enable = lib.mkEnableOption "Open WebUI browser-based chat interface for the local backend";
      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Port for the Open WebUI web interface";
      }; # end of webui port option
    }; # end of webui options
  }; # end of ai options

  # Open WebUI (optional, needs a local backend; connects to it on localhost)
  config = lib.mkIf (config.sysset.ai.enable && config.sysset.ai.webui.enable) {
    services.open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = config.sysset.ai.webui.port;
      openFirewall = true;
      environment = {
        OPENAI_API_BASE_URL = "http://127.0.0.1:${toString config.sysset.ai.port}/v1";
        OPENAI_API_KEY = "local-backend"; # local backend accepts any API key
        WEBUI_AUTH = "true";
      };
    }; # end of open-webui config
  }; # end of webui config
}
