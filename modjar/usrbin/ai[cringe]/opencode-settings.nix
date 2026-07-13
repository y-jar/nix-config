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
              "glm-4.7" = {
                name = "GLM 4.7";
                tool_call = true;
              }; # end of glm-4.7
              "qwen3-coder" = {
                name = "Qwen3 Coder";
                tool_call = true;
              }; # end of qwen3-coder
            }; # end of models
          }; # end of ollama
          lmstudio = {
            npm = "@ai-sdk/openai-compatible";
            name = "LM Studio";
            options = {
              baseURL = "http://localhost:1234/v1";
            }; # end of options
            models = {
              "zai-org/glm-4.6v-flash" = {
                name = "GLM 4.6V Flash";
                tool_call = true;
              }; # end of glm-4.6v-flash
              "mistralai/ministral-3-14b-reasoning" = {
                name = "Ministral 3 14B Reasoning";
                tool_call = true;
              }; # end of ministral-3-14b-reasoning
              "qwen/qwen3.5-9b" = {
                name = "Qwen3.5 9B";
                tool_call = true;
              }; # end of qwen3.5-9b
            }; # end of models
          }; # end of lmstudio
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
