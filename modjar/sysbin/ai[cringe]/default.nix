{ config, lib, pkgs, ... }:

let
  cfg = config.sysSettings.ai;

  llamaPackage =
    if cfg.gpu == "rocm" then pkgs.llama-cpp-rocm
    else if cfg.gpu == "cuda" then pkgs.llama-cpp-cuda
    else pkgs.llama-cpp;
in
{
  options = {
    sysSettings.ai = {
      enable = lib.mkEnableOption "Enable AI tools (~2GiB, llama.cpp + models)";
      port = lib.mkOption {
        type = lib.types.port;
        default = 11434;
        description = "Port for the llama.cpp API";
      };
      gpu = lib.mkOption {
        type = lib.types.enum [ "rocm" "cuda" "cpu" ];
        default = "rocm";
        description = "llama.cpp GPU backend: rocm (AMD), cuda (NVIDIA), or cpu";
      };
      webui = {
        enable = lib.mkEnableOption "Open WebUI — browser-based chat interface for llama.cpp";
        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          description = "Port for the Open WebUI web interface";
        }; # end of webui port option
      }; # end of webui options
    }; # end of ai options
  }; # end of options

  config = lib.mkMerge [
    # llama.cpp (always when ai is enabled)
    (lib.mkIf cfg.enable {
      services.llama-cpp = {
        enable = true;
        package = llamaPackage;
        host = "0.0.0.0"; # The host address which the llama-server HTTP interface listens to.
        port = cfg.port;
        openFirewall = true;
        # [models] auto-downloaded from HuggingFace on first request into /var/cache/llama-cpp
        modelsPreset = {
          "qwen3.5-9b" = {
            hf-repo = "unsloth/Qwen3.5-9B-GGUF";
            hf-file = "Qwen3.5-9B-UD-Q4_K_XL.gguf";
            alias = "qwen3.5-9b"; # model ID served by the API (matches opencode)
            fit = "on";
          }; # end of qwen3.5-9b preset
        }; # end of models preset
        extraFlags = [
          "-ngl"
          "999" # offload all layers to GPU
        ];
      }; # end of llama-cpp config
      # llama-cpp runs as a DynamicUser; grant access to /dev/kfd + /dev/dri/renderD*
      systemd.services.llama-cpp.serviceConfig = {
        SupplementaryGroups = [ "render" "video" ];
        # calender has an iGPU (gfx1036, no precompiled kernel in this ROCm build)
        # that llama.cpp otherwise splits the model across, causing GPU hangs and
        # ~4 t/s. Restrict ROCm to the dGPU (RX 9070 XT) only.
        Environment = lib.mkIf (cfg.gpu == "rocm") [ "ROCR_VISIBLE_DEVICES=0" ];
        # the nixpkgs llama-cpp module hardcodes ProcSubset=pid, which hides
        # /proc/meminfo and breaks llama-server's `--fit on` memory detection.
        ProcSubset = lib.mkForce "all";
      };
    }) # end of llama-cpp config

    # Open WebUI (optional, connects to llama.cpp on localhost)
    (lib.mkIf cfg.webui.enable {
      services.open-webui = {
        enable = true;
        host = "0.0.0.0";
        port = cfg.webui.port;
        openFirewall = true;
        environment = {
          OPENAI_API_BASE_URL = "http://127.0.0.1:${toString cfg.port}/v1";
          OPENAI_API_KEY = "llama.cpp"; # llama-server accepts any API key
          WEBUI_AUTH = "true";
        };
      }; # end of open-webui config
    }) # end of webui config
  ]; # end of config
}
