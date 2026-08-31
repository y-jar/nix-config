# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Prism Launcher (Minecraft).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.gaming.prism;
in
{
  options = {
    usrSettings.gaming.prism.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Prism Launcher (~200MiB)";
    }; # end of usrSettings.gaming.prism.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.prismlauncher
      pkgs.mcpelauncher-ui-qt # bedrock
      pkgs.zenity # mcpelauncher file picker / dialogs
    ]; # end of home.packages
  }; # end of config
}
