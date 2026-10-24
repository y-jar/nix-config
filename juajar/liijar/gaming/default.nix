# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: gaming: prismlauncher (+ bedrock/zenity extras) + heroic + protonplus per-toggle.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.gaming;

  # gaming packages, gated per usrset.gaming toggle
  gamingPackages =
    lib.optionals cfg.prism.enable [
      pkgs.prismlauncher
      pkgs.mcpelauncher-ui-qt # bedrock
      pkgs.zenity # mcpelauncher file picker / dialogs
    ]
    ++ lib.optionals cfg.heroic.enable [ pkgs.heroic ]
    ++ lib.optionals cfg.protonplus.enable [ pkgs.protonplus ];
in
{
  config = {
    packages = gamingPackages; # end of packages
  }; # end of config
}
