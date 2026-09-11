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
  cfg = config.usrset.gaming.prism;
in
{

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.prismlauncher
      pkgs.mcpelauncher-ui-qt # bedrock
      pkgs.zenity # mcpelauncher file picker / dialogs
    ]; # end of home.packages
  }; # end of config
}
