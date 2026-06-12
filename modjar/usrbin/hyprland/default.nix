{
  lib,
  config,
  hostnm,
  ...
}:
let
  cfg = config.usrSettings.hyprland;
in
{
  options = {
    usrSettings.hyprland.enable = lib.mkEnableOption {
      description = "Enable Hyprland";
    };
  };
  # imports = [ ./hyprland.nix ];

  # cconfig
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "hypr/hyprland.lua".source = ./base.lua; # base linker
      "hypr/hl".source = ./hl; # main config
      "hypr/host-inputs/input.lua".source = ./host-inputs/${hostnm}.lua; # host-specific inputs
    };
  };
}
