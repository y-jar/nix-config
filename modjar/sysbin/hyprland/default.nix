{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.hyprland;
in
{
  options = {
    sysSettings.hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    }; # end of programs.hyprland
    environment.systemPackages = with pkgs; [
      # [Hyprland Companion Apps]
      hyprshot # Utility to easily take screenshots in Hyprland using your mouse
      hyprlauncher # A multipurpose and versatile launcher / picker for Hyprland
      hyprlock # Hyprland’s GPU-accelerated screen locking utility
      hyprsunset # Application to enable a blue-light filter on Hyprland
    ]; # end of enviroment.systemPackages
  }; # end of config
}
