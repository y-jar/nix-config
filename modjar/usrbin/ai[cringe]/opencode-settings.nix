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
          llama = {
            npm = "@ai-sdk/openai-compatible";
            name = "llama.cpp (local)";
            options = {
              baseURL = "http://localhost:11434/v1";
            }; # end of options
            models = {
              "qwen3.5-9b" = {
                name = "Qwen3.5 9B";
                tool_call = true;
              }; # end of qwen3.5-9b
            }; # end of models
          }; # end of llama

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
