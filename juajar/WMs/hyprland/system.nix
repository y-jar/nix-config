# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Hyprland compositor (system-level enable).
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sysset.hyprland;
in
{
  options = {
    sysset.hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland (~19MiB)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    }; # end of programs.hyprland
    environment.systemPackages = [
      # [Hyprland Companion Apps :P ]
      pkgs.hyprshot # Utility to easily take screenshots in Hyprland using your mouse
      pkgs.hyprlauncher # A multipurpose and versatile launcher / picker for Hyprland
      pkgs.hyprlock # Hyprland’s GPU-accelerated screen locking utility
      pkgs.hyprsunset # Application to enable a blue-light filter on Hyprland
    ]; # end of enviroment.systemPackages
  }; # end of config
}
