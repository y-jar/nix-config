{
  lib,
  config,
  hostnm, pkgs,
  ...
}:
let
  cfg = config.usrSettings.hyprland; # hyprland settings
  hostSpecificFile = ./host-inputs + "/${hostnm}.lua"; # host-specific input
  targetLUASource =
    if builtins.pathExists hostSpecificFile then hostSpecificFile else ./host-inputs/0-unknown.lua;
in
{
  options = {
    usrSettings.hyprland.enable = lib.mkEnableOption {
      description = "Enable Hyprland";
    };
  };
  # imports = [ ./hyprland.nix ];

  # [config]
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "hypr/hyprland.lua".source = ./base.lua; # base linker
      "hypr/hl".source = ./hl; # main config
      "hypr/host-inputs/input.lua".source = targetLUASource; # host-specific inputs
    }; # end of xdg.configFile
    home.packages = with pkgs; [
      awww # animated wallpaper daemon for Wayland
      waypaper # GUI wallpaper setter for Wayland-based window managers
      hyprpicker # The mouse-following color picker
      woomer # Zoomer application for Wayland inspired by tsoding's boomer
    ];
  }; # end of config
}
