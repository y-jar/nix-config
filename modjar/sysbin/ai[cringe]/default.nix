{ config, lib, pkgs, ... }:

let
  cfg = config.sysSettings.ai;
in
{
  options = {
    sysSettings.ai = {
      enable = lib.mkEnableOption "Enable AI tools (Ollama, opencode, etc.)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm; # Swap to ollama-cuda for Nvidia, or ollama for CPU only
      # [models]
      loadModels = [
        "qwen3.5:9b"
        "qwen3.5:9b-mlx"
        "frob/ministral-3:14b"
        "frob/ministral-3:3b"
        "mistral:7b"
        "gemma4:latest"
      ];
    };
  };
}
