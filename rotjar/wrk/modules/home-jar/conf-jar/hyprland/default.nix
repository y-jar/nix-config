{ hostnm, ... }:
{
  # imports = [ ./hyprland.nix ];
  xdg.configFile = {
    "hypr/hyprland.lua".source = ./base.lua; # base linker
    "hypr/hl".source = ./hl; # main config
    "hypr/host-inputs/input.lua".source = ./host-inputs/${hostnm}.lua; # host-specific inputs
  };
}
