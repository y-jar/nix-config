# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Ollama backend (sysset.ai.ollama options + service config).
# -=-=-=-=-=-=-=-=-=-=-=
# Configured by hosts in `sysset.ai.ollama`. Model availability lives in
# ./models.nix (ollamaSets + customModels); `ollama-model-loader.service`
# pulls activeModels in the background after every switch/boot.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  aiCfg = config.sysset.ai;
  cfg = aiCfg.ollama;
  models = import ./models.nix;

  ollamaPackage =
    if cfg.gpu == "rocm" then
      pkgs.ollama-rocm
    else if cfg.gpu == "cuda" then
      pkgs.ollama-cuda
    else if cfg.gpu == "vulkan" then
      pkgs.ollama-vulkan
    else
      pkgs.ollama-cpu;

  activeOllamaModels =
    if cfg.modelSet == "small" then
      models.ollamaSets.small
    else if cfg.modelSet == "medium" then
      models.ollamaSets.medium
    else if cfg.modelSet == "large" then
      models.ollamaSets.large
    else
      cfg.customModels;
in
{
  options.sysset.ai.ollama = {
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
    flashAttention = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "OLLAMA_FLASH_ATTENTION (required for a quantized KV cache)";
    }; # end of ollama.flashAttention
    kvCache = lib.mkOption {
      type = lib.types.enum [
        "f16"
        "q8_0"
        "q4_0"
      ];
      default = "f16";
      description = "OLLAMA_KV_CACHE_TYPE (any value besides f16 needs flashAttention = true)";
    }; # end of ollama.kvCache
  }; # end of ollama options

  # Ollama only when ai.enable AND ai.ollama.enable
  config = lib.mkIf (aiCfg.enable && cfg.enable) {
    services.ollama = {
      enable = true;
      package = ollamaPackage;
      inherit (aiCfg) host;
      inherit (aiCfg) port;
      openFirewall = lib.mkIf (aiCfg.host == "0.0.0.0") true;
      loadModels = activeOllamaModels;
      syncModels = cfg.syncModels;
      environmentVariables =
        {
          OLLAMA_CONTEXT_LENGTH = toString cfg.contextLength;
          OLLAMA_KEEP_ALIVE = cfg.keepAlive;
        }
        // lib.optionalAttrs cfg.flashAttention {
          OLLAMA_FLASH_ATTENTION = "1";
        }
        // lib.optionalAttrs (cfg.kvCache != "f16") {
          OLLAMA_KV_CACHE_TYPE = cfg.kvCache;
        }
        // lib.optionalAttrs (cfg.gpu == "rocm" && cfg.devices != "") {
          ROCR_VISIBLE_DEVICES = cfg.devices;
        };
    }; # end of ollama config
    systemd.services.ollama.serviceConfig = {
      SupplementaryGroups = lib.mkForce [
        "render"
        "video"
      ];
    };
    boot.initrd.kernelModules = lib.mkIf (cfg.gpu == "rocm") [ "amdgpu" ];
    sysset.ai.ollama.activeModels = activeOllamaModels;
  }; # end of ollama config
}
