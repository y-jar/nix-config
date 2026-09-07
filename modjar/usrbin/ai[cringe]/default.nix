# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: User-level AI tools (opencode, LM Studio).
# Fine toggles: ai.enable (master), ai.opencode.enable, ai.lmstudio.enable,
# so you can keep opencode (non-local models) while skipping LM Studio's ~2.3GiB.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.ai;
in
{
  imports = [
    ./opencode.nix # the config for opencode
  ]; # end of imports

  options = {
    usrSettings.ai = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Master toggle for AI tooling (opencode / LM Studio)";
      }; # end of ai.enable
      opencode = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install opencode (CLI + desktop GUI). On by default when ai.enable";
        }; # end of ai.opencode.enable
      }; # end of ai.opencode
      lmstudio = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install LM Studio (~2.3GiB). Disable to keep opencode only";
        }; # end of ai.lmstudio.enable
      }; # end of ai.lmstudio
    }; # end of usrSettings.ai
  }; # end of options

  config = lib.mkIf cfg.enable {
    home.packages =
      (lib.optionals cfg.lmstudio.enable [ pkgs.lmstudio ])
      ++ (lib.optionals cfg.opencode.enable [ pkgs.opencode-desktop ]);
  }; # end of config
}
