# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Local llama.cpp server (sysset.ai.llama options + service config).
# -=-=-=-=-=-=-=-=-=-=-=
# Configured by hosts in `sysset.ai.llama`; model presets live in
# ./models.nix (llamaPresets): auto-downloaded from HuggingFace on first
# request into /var/cache/llama-cpp.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  aiCfg = config.sysset.ai;
  cfg = aiCfg.llama;
  models = import ./models.nix;

  llamaPackage =
    if cfg.gpu == "rocm" then
      pkgs.llama-cpp-rocm
    else if cfg.gpu == "cuda" then
      pkgs.llama-cpp-cuda
    else
      pkgs.llama-cpp;
in
{
  options.sysset.ai.llama = {
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

  # llama.cpp only when ai.enable AND ai.llama.enable
  config = lib.mkIf (aiCfg.enable && cfg.enable) {
    services.llama-cpp = {
      enable = true;
      package = llamaPackage;
      inherit (aiCfg) host; # The host address which the llama-server HTTP interface listens to.
      inherit (aiCfg) port;
      openFirewall = lib.mkIf (aiCfg.host == "0.0.0.0") true;
      modelsPreset = models.llamaPresets;
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
      Environment = lib.mkIf (cfg.gpu == "rocm") [ "ROCR_VISIBLE_DEVICES=0" ];
      # the nixpkgs llama-cpp module hardcodes ProcSubset=pid, which hides
      # /proc/meminfo and breaks llama-server's `--fit on` memory detection.
      ProcSubset = lib.mkForce "all";
    };
  }; # end of llama-cpp config
}
