{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.sysset.ai;

  llamaPackage =
    if cfg.llama.gpu == "rocm" then
      pkgs.llama-cpp-rocm
    else if cfg.llama.gpu == "cuda" then
      pkgs.llama-cpp-cuda
    else
      pkgs.llama-cpp;

  ollamaPackage =
    if cfg.ollama.gpu == "rocm" then
      pkgs.ollama-rocm
    else if cfg.ollama.gpu == "cuda" then
      pkgs.ollama-cuda
    else if cfg.ollama.gpu == "vulkan" then
      pkgs.ollama-vulkan
    else
      pkgs.ollama-cpu;

  activeOllamaModels =
    if cfg.ollama.modelSet == "small" then
      [
        "qwen2.5-coder:7b"
        "qwen3.5:9b"
      ]
    else if cfg.ollama.modelSet == "medium" then
      [
        "qwen2.5-coder:14b"
        "qwen3.5:9b"
      ]
    else if cfg.ollama.modelSet == "large" then
      [
        "qwen2.5-coder:32b"
        "qwen3.5:27b"
        "qwen3:30b-a3b"
      ]
    else
      cfg.ollama.customModels;
in
{
  options = {
    sysset.ai = {
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
      llama = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Local llama.cpp server (~2GiB, GPU backend). Set false to skip local inference entirely";
        }; # end of llama.enable
        gpu = lib.mkOption {
          type = lib.types.enum [
            "rocm"
            "cuda"
            "cpu"
          ];
          default = "rocm";
          description = "llama.cpp GPU backend: rocm (AMD), cuda (NVIDIA), or cpu. ROCm adds ~2.7GiB";
        }; # end of llama.gpu
      }; # end of llama options
      ollama = {
        enable = lib.mkEnableOption "Ollama server (multi-GPU capable local LLM backend)";
        gpu = lib.mkOption {
          type = lib.types.enum [
            "rocm"
            "cuda"
            "vulkan"
            "cpu"
          ];
          default = "rocm";
          description = "Ollama GPU backend: rocm (AMD), cuda (NVIDIA), vulkan, or cpu";
        }; # end of ollama.gpu
        contextLength = lib.mkOption {
          type = lib.types.int;
          default = 8192;
          description = "Default context length (OLLAMA_CONTEXT_LENGTH) for models served by Ollama";
        }; # end of ollama.contextLength
        devices = lib.mkOption {
          type = lib.types.str;
          default = "0,1";
          description = "Comma-separated GPU UUIDs/indices exposed to Ollama via ROCR_VISIBLE_DEVICES (prefer UUIDs; use to exclude iGPUs)";
        }; # end of ollama.devices
        modelSet = lib.mkOption {
          type = lib.types.enum [
            "small"
            "medium"
            "large"
            "custom"
          ];
          default = "medium";
          description = "Curated Ollama model set: small, medium, large, or custom";
        }; # end of ollama.modelSet
        customModels = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Ollama model tags used when modelSet = custom";
        }; # end of ollama.customModels
        activeModels = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          readOnly = true;
          description = "Resolved Ollama model tags for the active modelSet";
        }; # end of ollama.activeModels
        syncModels = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Remove Ollama models not listed in the active set";
        }; # end of ollama.syncModels
        keepAlive = lib.mkOption {
          type = lib.types.str;
          default = "5m";
          description = "OLLAMA_KEEP_ALIVE value for loaded models";
        }; # end of ollama.keepAlive
      }; # end of ollama options
      webui = {
        enable = lib.mkEnableOption "Open WebUI browser-based chat interface for the local backend";
        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          description = "Port for the Open WebUI web interface";
        }; # end of webui port option
      }; # end of webui options
    }; # end of ai options
  }; # end of options

  config = lib.mkMerge [
    # llama.cpp (only when ai.enable AND ai.llama.enable)
    (lib.mkIf (cfg.enable && cfg.llama.enable) {
      services.llama-cpp = {
        enable = true;
        package = llamaPackage;
        inherit (cfg) host; # The host address which the llama-server HTTP interface listens to.
        inherit (cfg) port;
        openFirewall = lib.mkIf (cfg.host == "0.0.0.0") true;
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
        SupplementaryGroups = [
          "render"
          "video"
        ];
        # Some hosts have an iGPU without a precompiled ROCm kernel; llama.cpp
        # would otherwise split the model across devices, causing GPU hangs and
        # poor throughput. Restrict ROCm to the first (d)GPU.
        Environment = lib.mkIf (cfg.llama.gpu == "rocm") [ "ROCR_VISIBLE_DEVICES=0" ];
        # the nixpkgs llama-cpp module hardcodes ProcSubset=pid, which hides
        # /proc/meminfo and breaks llama-server's `--fit on` memory detection.
        ProcSubset = lib.mkForce "all";
      };
    }) # end of llama-cpp config

    # Ollama (only when ai.enable AND ai.ollama.enable)
    (lib.mkIf (cfg.enable && cfg.ollama.enable) {
      services.ollama = {
        enable = true;
        package = ollamaPackage;
        inherit (cfg) host;
        inherit (cfg) port;
        openFirewall = lib.mkIf (cfg.host == "0.0.0.0") true;
        loadModels = activeOllamaModels;
        syncModels = cfg.ollama.syncModels;
        environmentVariables =
          {
            OLLAMA_CONTEXT_LENGTH = toString cfg.ollama.contextLength;
            OLLAMA_KEEP_ALIVE = cfg.ollama.keepAlive;
          }
          // lib.optionalAttrs (cfg.ollama.gpu == "rocm" && cfg.ollama.devices != "") {
            ROCR_VISIBLE_DEVICES = cfg.ollama.devices;
          };
      }; # end of ollama config
      systemd.services.ollama.serviceConfig = {
        SupplementaryGroups = lib.mkForce [
          "render"
          "video"
        ];
      };
      boot.initrd.kernelModules = lib.mkIf (cfg.ollama.gpu == "rocm") [ "amdgpu" ];
      sysset.ai.ollama.activeModels = activeOllamaModels;
    }) # end of ollama config

    # Open WebUI (optional, needs a local backend; connects to it on localhost)
    (lib.mkIf (cfg.enable && cfg.webui.enable) {
      services.open-webui = {
        enable = true;
        host = "0.0.0.0";
        port = cfg.webui.port;
        openFirewall = true;
        environment = {
          OPENAI_API_BASE_URL = "http://127.0.0.1:${toString cfg.port}/v1";
          OPENAI_API_KEY = "local-backend"; # local backend accepts any API key
          WEBUI_AUTH = "true";
        };
      }; # end of open-webui config
    }) # end of webui config
  ]; # end of config
}
