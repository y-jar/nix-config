# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: User-level AI tools (LM Studio, opencode).
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
    usrSettings.ai.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AI tools (~1.5GiB, LM Studio + opencode)";
    }; # end of ai.enable
  }; # end of options
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lmstudio # for ai
      opencode-desktop # opencode gui
    ]; # end of home.packages
  }; # end of config
}
