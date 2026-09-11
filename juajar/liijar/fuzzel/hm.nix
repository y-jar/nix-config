# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Fuzzel app launcher + scripts (home-manager side).
# -=-=-=-=-=-=-=-=-=-=-=
# Unified gate: any wayland compositor (niri/hyprland) or the launcher toggle.
# The ini settings + helper scripts + package bucket live in ./shared.nix.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf (cfg.niri.enable || cfg.hyprland.enable || cfg.launcher.enable) {
    programs.fuzzel = {
      enable = true;
      settings = shared.settings;
    }; # end of fuzzel

    # launcher helper scripts + the fuzzel binary (see shared.nix)
    home.packages = shared.packages;
  }; # end of config
}
