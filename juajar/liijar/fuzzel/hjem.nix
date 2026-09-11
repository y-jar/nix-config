# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Fuzzel app launcher + scripts (hjem side).
# -=-=-=-=-=-=-=-=-=-=-=
# Generates ~/.config/fuzzel/fuzzel.ini (translucent colorless glass) from
# the shared settings, so hjem hosts get the same launcher as the
# home-manager backend. Unified gate: any wayland compositor
# (niri/hyprland) or the launcher toggle. Settings/scripts live in
# ./shared.nix.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset;
  shared = import ./shared.nix { inherit cfg pkgs lib; };

  ini = pkgs.formats.ini { };
in
{
  config = lib.mkIf (cfg.niri.enable || cfg.hyprland.enable || cfg.launcher.enable) {
    packages = shared.packages;
    files.".config/fuzzel/fuzzel.ini".source = ini.generate "fuzzel.ini" shared.settings;
  }; # end of config
}
