{
  lib,
  config,
  hostnm,
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
  }; # end of config
}
