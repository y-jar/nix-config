# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Shelljar quickshell island shell (wiring + kdl).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[shelljar] =-=-=
# My custom Quickshell island shell (replaces noctalia on hosts that opt in).
# ref: https://github.com/y-jar/shelljar (flake input, built via its own flake)
# To enable: hstjar/<host>/home.nix -> usrSettings.shelljar.enable = true;
# The compositor modules (niri/hyprland) read this flag to pick the shell to spawn.
# =-=-=[end shelljar] =-=-=

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.usrSettings.shelljar;
in
{
  options = {
    usrSettings.shelljar.enable = lib.mkEnableOption "shelljar (my quickshell island shell)";
  }; # end of options

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.shelljar.packages.${pkgs.stdenv.hostPlatform.system}.default # the shell binary
    ];
    xdg.configFile = {
      "shelljar/config.kdl".source = ./config.kdl; # synced shelljar config (wallpaper dir + carousel)
    };
  }; # end of config
}
