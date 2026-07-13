{ config, lib, ... }:
let
  cfg = config.usrSettings.ai;
in
{
  config = lib.mkIf cfg.enable {
    programs.opencode = {
      settings = {
        # provider configuration for local models
        provider = {
          ollama = {
            npm = "@ai-sdk/openai-compatible";
            name = "Ollama (local)";
            options = {
              baseURL = "http://localhost:11434/v1";
            }; # end of options
            models = {
              "qwen3.5:9b" = {
                name = "Qwen3.5 9B";
                tool_call = true;
              }; # end of qwen3.5:9b
              "qwen3.5:9b-mlx" = {
                name = "Qwen3.5 9B (MLX)";
                tool_call = true;
              }; # end of qwen3.5:9b-mlx
              "frob/ministral-3:14b" = {
                name = "Ministral 3 14B";
                tool_call = true;
              }; # end of frob/ministral-3:14b
              "frob/ministral-3:3b" = {
                name = "Ministral 3 3B";
                tool_call = true;
              }; # end of frob/ministral-3:3b
              "mistral:7b" = {
                name = "Mistral 7B";
                tool_call = true;
              }; # end of mistral:7b
              "gemma4:latest" = {
                name = "Gemma 4";
                tool_call = true;
              }; # end of gemma4:latest
            }; # end of models
          }; # end of ollama

        }; # end of provider

        # permissions (order matters: last matching rule wins)
        # permission = {
        #   bash = {
        #     "git *": "allow";
        #     "nix *": "allow";
        #     "nh *": "allow";
        #     "*": "ask";
        #   }; # end of bash
        # }; # end of permission
      }; # end of settings
    }; # end of opencode
  }; # end of config
}
